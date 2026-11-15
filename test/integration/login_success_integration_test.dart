import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:ubb/screens/login_screen.dart';
import 'package:ubb/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('LoginScreen + AuthService Mockeado - Pruebas de Integración (Login Exitoso)', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    Widget createWidgetUnderTest() {
      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Text('Pantalla Principal Home UBB'),
            ),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const Scaffold(
              body: Text('Pantalla de Registro'),
            ),
          ),
        ],
      );

      return ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      );
    }

    testWidgets(
      'Con credenciales válidas se invoca login() una sola vez y se redirige a /home',
      (WidgetTester tester) async {
        const testEmail = 'estudiante.test@alumnos.ubiobio.cl';
        const testPassword = 'PasswordUbb2026';

        // Configuramos el mock para simular éxito (retorna null en caso de éxito)
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => null);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Localizamos los campos y el botón
        final emailInput = find.widgetWithText(TextFormField, 'Correo electrónico');
        final passwordInput = find.widgetWithText(TextFormField, 'Contraseña');
        final submitButton = find.widgetWithText(MaterialButton, 'Ingresar');

        // Llenamos las credenciales válidas
        await tester.enterText(emailInput, testEmail);
        await tester.enterText(passwordInput, testPassword);
        await tester.pumpAndSettle();

        // Pulsamos el botón de ingreso
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // 1. Verificamos que se llamó a login() exactamente una vez con los datos ingresados
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);

        // 2. Verificamos que tras el login exitoso se navega a la pantalla Home
        expect(find.text('Pantalla Principal Home UBB'), findsOneWidget);
      },
    );
  });
}

