import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = dotenv.env['FIREBASE_TOKEN'] ?? '';

  final storage = const FlutterSecureStorage();

  Future<String?> createUser(
      String nombre, String apellido, String email, String password) async {
    final Map<String, dynamic> authData = {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);

      // Concatenar nombre y apellido para establecer el displayName
      final displayName = '$nombre $apellido';
      await setDisplayName(displayName);

      // Enviar correo electrónico de verificación
      await sendEmailVerification();
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      final token = decodedResp['idToken'];
      await storage.write(key: 'token', value: token);

      final userData = await getUserData(); // Obtener datos del usuario
      final isEmailVerified = userData?['emailVerified'] ??
          false; // Verificar si el correo está verificado

      if (!isEmailVerified) {
        // Cerrar sesión y borrar el token si el correo no está verificado
        await logout();
        return 'El correo electrónico no ha sido verificado. Por favor, verifica tu correo antes de iniciar sesión.';
      }

      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final token = await readToken();
      if (token.isEmpty) {
        return null;
      }

      final url = Uri.https(_baseUrl, '/v1/accounts:lookup', {
        'key': _firebaseToken,
      });

      final payload = {
        'idToken': token,
      };

      final resp = await http.post(url, body: json.encode(payload));

      if (resp.statusCode == 200) {
        final Map<String, dynamic> decodedResp = json.decode(resp.body);

        if (decodedResp.containsKey('users')) {
          final userData = decodedResp['users'][0];
          return userData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<void> setDisplayName(String displayName) async {
    final token = await readToken();
    if (token.isEmpty) {
      return;
    }

    final url = Uri.https(_baseUrl, '/v1/accounts:update', {
      'key': _firebaseToken,
    });

    final payload = {
      'idToken': token,
      'displayName': displayName,
    };

    await http.post(url, body: json.encode(payload));
  }

  Future<void> sendEmailVerification() async {
    final token = await readToken();
    if (token.isEmpty) {
      return;
    }

    final url = Uri.https(_baseUrl, '/v1/accounts:sendOobCode', {
      'key': _firebaseToken,
    });

    final payload = {
      'requestType': 'VERIFY_EMAIL',
      'idToken': token,
    };

    await http.post(url, body: json.encode(payload));
  }

  Future<String?> resetPassword(String email) async {
    final url = Uri.https(
        _baseUrl, '/v1/accounts:sendOobCode', {'key': _firebaseToken});

    final payload = {
      'requestType': 'PASSWORD_RESET',
      'email': email,
    };

    final response = await http.post(url, body: json.encode(payload));
    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('email')) {
      return null; // Éxito: no hay mensaje de error
    } else {
      final errorMessage = decodedResp['error']['message'];
      return errorMessage; // Error: mensaje de error
    }
  }
}
