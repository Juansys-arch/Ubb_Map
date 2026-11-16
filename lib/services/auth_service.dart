import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final FirebaseAuth? _auth;
  final FlutterSecureStorage storage;
  final http.Client _client;
  final String? _baseUrl;

  AuthService({
    FirebaseAuth? auth,
    FlutterSecureStorage? storage,
    http.Client? client,
    String? baseUrl,
  })  : _auth = auth,
        storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  String get _resolvedBaseUrl {
    final url = (_baseUrl ?? dotenv.env['API_URL'] ?? '').replaceFirst(RegExp(r'/$'), '');
    return url;
  }

  // Registro de usuarios nativo en MongoDB
  Future<String?> createUser(
    String nombre,
    String apellido,
    String email,
    String password,
  ) async {
    try {
      final baseUrl = _resolvedBaseUrl;
      if (baseUrl.isEmpty) {
        return 'API_URL no está configurada en environments/.env';
      }

      final displayName = '$nombre $apellido'.trim();
      final cleanEmail = email.trim().toLowerCase();

      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': cleanEmail,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
          'displayName': displayName,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = data['token']?.toString() ?? '';
        final uid = (data['uid'] ?? data['id'])?.toString() ?? '';
        final userEmail = data['email']?.toString() ?? cleanEmail;

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'userId', value: uid);
        await storage.write(key: 'userEmail', value: userEmail);
        await storage.write(key: 'displayName', value: displayName);
        await storage.write(
          key: 'createdAt',
          value: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        notifyListeners();
        return null;
      } else {
        return data['error']?.toString() ?? 'Error al registrar la cuenta.';
      }
    } on SocketException {
      return 'No se pudo conectar con el servidor backend. Verifica tu conexión.';
    } on TimeoutException {
      return 'El servidor tardó demasiado en responder (Timeout).';
    } catch (e) {
      return 'Error de registro: $e';
    }
  }

  // Inicio de sesión nativo en MongoDB
  Future<String?> login(String email, String password) async {
    try {
      final baseUrl = _resolvedBaseUrl;
      if (baseUrl.isEmpty) {
        return 'API_URL no está configurada en environments/.env';
      }

      final cleanEmail = email.trim().toLowerCase();
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': cleanEmail,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = data['token']?.toString() ?? '';
        final uid = (data['uid'] ?? data['id'])?.toString() ?? '';
        final userEmail = data['email']?.toString() ?? cleanEmail;
        final displayName = data['displayName']?.toString() ?? '';

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'userId', value: uid);
        await storage.write(key: 'userEmail', value: userEmail);
        if (displayName.isNotEmpty) {
          await storage.write(key: 'displayName', value: displayName);
        }

        notifyListeners();
        return null;
      } else {
        return data['error']?.toString() ?? 'Credenciales inválidas.';
      }
    } on SocketException {
      return 'No se pudo conectar con el servidor backend. Verifica tu conexión.';
    } on TimeoutException {
      return 'El servidor tardó demasiado en responder (Timeout).';
    } catch (e) {
      return 'Error al iniciar sesión: $e';
    }
  }

  // Obtener información del usuario autenticado
  Future<Map<String, dynamic>?> getUserData() async {
    final token = await readToken();
    if (token.isEmpty) {
      return null;
    }

    final email = await storage.read(key: 'userEmail') ?? '';
    final uid = await storage.read(key: 'userId') ?? '';
    final displayName = await storage.read(key: 'displayName') ?? '';
    final createdAt = await storage.read(key: 'createdAt') ??
        DateTime.now().millisecondsSinceEpoch.toString();

    return {
      'displayName': displayName,
      'email': email,
      'createdAt': createdAt,
      'localId': uid,
      'emailVerified': true,
    };
  }

  // Cerrar sesión
  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'userId');
    await storage.delete(key: 'userEmail');
    await storage.delete(key: 'displayName');
    await storage.delete(key: 'createdAt');

    try {
      await _auth?.signOut();
    } catch (_) {}

    notifyListeners();
  }

  // Leer token JWT guardado
  Future<String> readToken() async {
    final token = await storage.read(key: 'token');
    return token ?? '';
  }

  // Recuperación de contraseña con MongoDB
  Future<String?> resetPassword(String email) async {
    try {
      final baseUrl = _resolvedBaseUrl;
      if (baseUrl.isEmpty) {
        return 'API_URL no está configurada en environments/.env';
      }

      final response = await _client.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email.trim().toLowerCase()}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null;
      }
      final data = json.decode(response.body);
      return data['error']?.toString() ??
          'El correo electrónico ingresado no está registrado.';
    } catch (_) {
      return null;
    }
  }
}
