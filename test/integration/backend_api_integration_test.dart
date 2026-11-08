import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ubb/models/user_model.dart';

void main() {
  group('App <-> Backend Real (Node.js + MongoDB) - Pruebas de Integración', () {
    // URL base según el entorno de ejecución
    const String backendBaseUrl = 'http://localhost:3000';
    // Constante para emulador Android si se prueba en dispositivo
    // const String backendBaseUrlAndroid = 'http://10.0.2.2:3000';

    const testValidEmail = 'test.qa@alumnos.ubiobio.cl';
    const testValidPassword = 'PasswordQA2026';

    test(
      'POST /api/auth/login con credenciales inválidas devuelve status 400 o 401 y mensaje de error',
      () async {
        final url = Uri.parse('$backendBaseUrl/api/auth/login');

        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': 'usuario.inexistente@alumnos.ubiobio.cl',
              'password': 'PasswordIncorrecta999',
            }),
          ).timeout(const Duration(seconds: 5));

          // El backend de Node.js devuelve 400 ante credenciales inválidas
          expect(response.statusCode, anyOf(equals(400), equals(401)));

          final data = json.decode(response.body) as Map<String, dynamic>;
          expect(data.containsKey('error'), isTrue);
          expect(data['error'], isNotEmpty);
        } on SocketException catch (e) {
          printOnFailure(
            'El backend Node.js en $backendBaseUrl no está levantado: $e. '
            'Para ejecutar esta prueba con el backend real, inicia: cd Backend && node server.js',
          );
        } on http.ClientException catch (e) {
          printOnFailure(
            'Conexión rechazada con el backend Node.js en $backendBaseUrl: $e. '
            'Asegúrate de tener levantado MongoDB y "node server.js" en Backend.',
          );
        }
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'POST /api/auth/login con credenciales válidas devuelve 200, token JWT y modelo de usuario consistente',
      () async {
        final url = Uri.parse('$backendBaseUrl/api/auth/login');

        try {
          // Intentamos primero registrar el usuario de prueba para asegurar su existencia
          final registerUrl = Uri.parse('$backendBaseUrl/api/auth/register');
          await http.post(
            registerUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': testValidEmail,
              'password': testValidPassword,
            }),
          ).timeout(const Duration(seconds: 5));

          // Realizamos el login con credenciales válidas
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': testValidEmail,
              'password': testValidPassword,
            }),
          ).timeout(const Duration(seconds: 5));

          expect(response.statusCode, equals(200));

          final Map<String, dynamic> responseData =
              json.decode(response.body) as Map<String, dynamic>;

          // Verificamos presencia de token, uid y email
          expect(responseData['token'], isNotNull);
          expect(responseData['token'].toString(), isNotEmpty);
          expect(responseData['email'], equals(testValidEmail));

          // Verificamos que se parsee de forma íntegra con UserModel
          final userModel = UserModel.fromJson(responseData);
          expect(userModel.token, isNotEmpty);
          expect(userModel.email, equals(testValidEmail));
        } on SocketException catch (e) {
          printOnFailure(
            'El backend Node.js en $backendBaseUrl no está levantado: $e. '
            'Para ejecutar esta prueba con el backend real, inicia: cd Backend && node server.js',
          );
        } on http.ClientException catch (e) {
          printOnFailure(
            'Conexión rechazada con el backend Node.js en $backendBaseUrl: $e. '
            'Asegúrate de tener levantado MongoDB y "node server.js" en Backend.',
          );
        }
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });
}

