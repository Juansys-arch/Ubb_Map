import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/providers/login_form_provider.dart';

void main() {
  group('LoginFormProvider - Pruebas Unitarias', () {
    late LoginFormProvider loginFormProvider;

    setUp(() {
      loginFormProvider = LoginFormProvider();
    });

    test('Valores iniciales correctos (isLoading en false, email y password vacíos)', () {
      expect(loginFormProvider.isLoading, isFalse);
      expect(loginFormProvider.email, isEmpty);
      expect(loginFormProvider.password, isEmpty);
      expect(loginFormProvider.formKey, isNotNull);
    });

    test('Cambiar isLoading a true notifica a los listeners', () {
      var listenerNotified = false;
      loginFormProvider.addListener(() {
        listenerNotified = true;
      });

      loginFormProvider.isLoading = true;

      expect(loginFormProvider.isLoading, isTrue);
      expect(listenerNotified, isTrue);
    });

    test('Alternar isLoading de true a false notifica dos veces en total', () {
      int notificationsCount = 0;
      loginFormProvider.addListener(() {
        notificationsCount++;
      });

      loginFormProvider.isLoading = true;
      expect(loginFormProvider.isLoading, isTrue);
      expect(notificationsCount, equals(1));

      loginFormProvider.isLoading = false;
      expect(loginFormProvider.isLoading, isFalse);
      expect(notificationsCount, equals(2));
    });

    test('Actualización de campos email y password', () {
      loginFormProvider.email = 'estudiante@alumnos.ubiobio.cl';
      loginFormProvider.password = 'UbbPassword2026';

      expect(loginFormProvider.email, equals('estudiante@alumnos.ubiobio.cl'));
      expect(loginFormProvider.password, equals('UbbPassword2026'));
    });
  });
}

