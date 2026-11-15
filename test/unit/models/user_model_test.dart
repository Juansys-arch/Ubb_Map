import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/models/user_model.dart';

void main() {
  group('UserModel (Respuesta de Login / Usuario) - Pruebas Unitarias', () {
    test('fromJson parsea correctamente token, uid y email devueltos por el backend', () {
      final Map<String, dynamic> backendJson = {
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_token',
        'uid': '654321abcdef0987654321ab',
        'email': 'estudiante.test@alumnos.ubiobio.cl',
        'displayName': 'Estudiante UBB',
      };

      final user = UserModel.fromJson(backendJson);

      expect(user.token, equals('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_token'));
      expect(user.uid, equals('654321abcdef0987654321ab'));
      expect(user.email, equals('estudiante.test@alumnos.ubiobio.cl'));
      expect(user.displayName, equals('Estudiante UBB'));
    });

    test('fromJson tolera identificadores alternativos (id en lugar de uid) y nulos', () {
      final Map<String, dynamic> altJson = {
        'token': 'jwt_alternative_token',
        'id': 'alt_user_id_123',
        'email': 'usuario@ubiobio.cl',
      };

      final user = UserModel.fromJson(altJson);

      expect(user.token, equals('jwt_alternative_token'));
      expect(user.uid, equals('alt_user_id_123'));
      expect(user.email, equals('usuario@ubiobio.cl'));
      expect(user.displayName, isNull);
    });

    test('El ciclo toJson / fromJson es consistente y bidireccional', () {
      final originalUser = UserModel(
        token: 'sample.jwt.token',
        uid: 'user_9999',
        email: 'test@alumnos.ubiobio.cl',
        displayName: 'Test User',
      );

      final jsonMap = originalUser.toJson();
      final parsedUser = UserModel.fromJson(jsonMap);

      expect(parsedUser.token, equals(originalUser.token));
      expect(parsedUser.uid, equals(originalUser.uid));
      expect(parsedUser.email, equals(originalUser.email));
      expect(parsedUser.displayName, equals(originalUser.displayName));
      expect(parsedUser, equals(originalUser));
    });

    test('fromRawJson y toRawJson serializan y deserializan cadenas JSON válidas', () {
      final rawString = json.encode({
        'token': 'token_abc',
        'uid': 'uid_123',
        'email': 'alumno@alumnos.ubiobio.cl',
      });

      final user = UserModel.fromRawJson(rawString);
      expect(user.token, equals('token_abc'));
      expect(user.uid, equals('uid_123'));
      expect(user.email, equals('alumno@alumnos.ubiobio.cl'));

      final encoded = user.toRawJson();
      final decodedMap = json.decode(encoded) as Map<String, dynamic>;
      expect(decodedMap['token'], equals('token_abc'));
      expect(decodedMap['email'], equals('alumno@alumnos.ubiobio.cl'));
    });
  });
}

