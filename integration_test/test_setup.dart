import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ubb/models/user_model.dart';
import 'package:ubb/services/api_service.dart';

Future<void> initializeIntegrationTest({bool initializeFirebase = true}) async {
  if (!dotenv.isInitialized) {
    await dotenv.load(fileName: 'environments/.env');
  }

  if (initializeFirebase && Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

Future<UserModel>? _cachedMongoTestUser;

Future<UserModel> loginMongoTestUser() {
  return _cachedMongoTestUser ??= _loginMongoTestUser();
}

Future<UserModel> _loginMongoTestUser() async {
  const email = String.fromEnvironment(
    'TEST_EMAIL',
    defaultValue: 'test.qa@alumnos.ubiobio.cl',
  );
  const password = String.fromEnvironment(
    'TEST_PASSWORD',
    defaultValue: 'PasswordQA2026',
  );

  const testApiUrl = String.fromEnvironment('TEST_API_URL');
  final apiUrl = testApiUrl.isNotEmpty ? testApiUrl : dotenv.env['API_URL'];
  if (apiUrl == null || apiUrl.isEmpty) {
    throw StateError('API_URL no está configurada en environments/.env');
  }

  late final http.Response response;
  try {
    response = await http
        .post(
          Uri.parse('${apiUrl.replaceFirst(RegExp(r'/$'), '')}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 15));
  } on TimeoutException {
    throw StateError(
      'No hubo respuesta de la API en 15 segundos: $apiUrl. '
      'Verifica que el backend esté ejecutándose y que TEST_API_URL sea '
      'accesible desde el dispositivo.',
    );
  } on SocketException catch (error) {
    throw StateError('No se pudo conectar con la API $apiUrl: $error');
  }

  if (response.statusCode != 200) {
    final responseBody = response.body.trim();
    throw StateError(
      'El login de prueba contra MongoDB falló con HTTP '
      '${response.statusCode}: $responseBody. Verifica que el usuario exista '
      'en MongoDB y que la contraseña sea correcta.',
    );
  }

  final data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) {
    throw const FormatException('Respuesta de login inválida.');
  }

  final user = UserModel.fromJson(data);
  if (user.uid.isEmpty) {
    throw const FormatException('El login no devolvió uid.');
  }
  return user;
}

ApiService createTestApiService() {
  const testApiUrl = String.fromEnvironment('TEST_API_URL');
  return testApiUrl.isEmpty ? ApiService() : ApiService(baseUrl: testApiUrl);
}

Future<void> pauseForDemo([
  Duration duration = const Duration(seconds: 2),
]) {
  return Future<void>.delayed(duration);
}
