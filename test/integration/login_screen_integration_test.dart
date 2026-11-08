import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:ubb/screens/login_screen.dart';
import 'package:ubb/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('LoginScreen + LoginFormProvider - Pruebas de Integración', () {
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
            builder: (context, state) => const Scaffold(body: Text('Home Screen')),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const Scaffold(body: Text('Register Screen')),
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
      'Al ingresar un email inválido y presionar "Ingresar", se muestra error de validación y no se llama a login()',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Buscamos los inputs de texto
        final emailField = find.widgetWithText(TextFormField, 'Correo electrónico');
        final passwordField = find.widgetWithText(TextFormField, 'Contraseña');
        final submitButton = find.widgetWithText(MaterialButton, 'Ingresar');

        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(submitButton, findsOneWidget);

        // Ingresamos un correo inválido (no UBB) y contraseña corta
        await tester.enterText(emailField, 'correo_invalido@gmail.com');
        await tester.enterText(passwordField, '123');
        await tester.pumpAndSettle();

        // Presionamos el botón de ingreso
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Debe aparecer el mensaje de validación en pantalla
        expect(find.text('El correo no es válido.'), findsOneWidget);
        expect(find.text('La contraseña debe contener al menos 6 caracteres.'), findsOneWidget);

        // El formulario no debe enviarse: login() nunca es invocado
        verifyNever(() => mockAuthService.login(any(), any()));
      },
    );

    testWidgets(
      'Al dejar los campos vacíos y presionar "Ingresar", se muestran los errores requeridos',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final submitButton = find.widgetWithText(MaterialButton, 'Ingresar');
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Ambos campos deben mostrar "Debes rellenar el campo de texto."
        expect(find.text('Debes rellenar el campo de texto.'), findsNWidgets(2));
        verifyNever(() => mockAuthService.login(any(), any()));
      },
    );
  });
}

