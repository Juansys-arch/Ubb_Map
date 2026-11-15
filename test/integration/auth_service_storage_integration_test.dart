import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubb/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService + FlutterSecureStorage - Pruebas de Integración', () {
    late MockFirebaseAuth mockAuth;
    const storage = FlutterSecureStorage();

    setUp(() {
      mockAuth = MockFirebaseAuth();
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
    });

    test('readToken() retorna el token previamente almacenado en FlutterSecureStorage', () async {
      FlutterSecureStorage.setMockInitialValues({
        'token': 'jwt_guardado_test_123',
        'userId': 'usr_mock_456',
      });

      final authService = AuthService(auth: mockAuth, storage: storage);

      final token = await authService.readToken();

      expect(token, equals('jwt_guardado_test_123'));
    });

    test('logout() borra el token, refreshToken y userId de FlutterSecureStorage', () async {
      FlutterSecureStorage.setMockInitialValues({
        'token': 'jwt_para_borrar_999',
        'refreshToken': 'refresh_mock_999',
        'userId': 'usr_mock_999',
      });

      final authService = AuthService(auth: mockAuth, storage: storage);

      // Verificamos presencia inicial
      expect(await authService.readToken(), equals('jwt_para_borrar_999'));

      // Ejecutamos logout
      await authService.logout();

      // Verificamos que se invocó signOut en Firebase
      verify(() => mockAuth.signOut()).called(1);

      // Verificamos que readToken retorne string vacío tras borrar
      final tokenDespues = await authService.readToken();
      expect(tokenDespues, isEmpty);

      // Verificamos directamente en storage que las llaves fueron eliminadas
      expect(await storage.read(key: 'token'), isNull);
      expect(await storage.read(key: 'refreshToken'), isNull);
      expect(await storage.read(key: 'userId'), isNull);
    });
  });
}

