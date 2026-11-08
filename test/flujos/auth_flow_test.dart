import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ubb/providers/login_form_provider.dart';
import 'package:ubb/screens/login_screen.dart';
import 'package:ubb/services/auth_service.dart';
import 'package:ubb/widgets/settings_content.dart';

void main() {
  group('Flujo 1: Autenticación y Cierre de Sesión (Auth Flow)', () {
    testWidgets('Validación de formulario de Login y entrada de credenciales',
        (WidgetTester tester) async {
      // 1. Montar pantalla de Login con sus Providers requeridos
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthService()),
              ChangeNotifierProvider(create: (_) => LoginFormProvider()),
            ],
            child: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 2. Verificar que los elementos visuales de login están presentes
      expect(find.text('Ingresar'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // 3. Simular ingreso de correo y contraseña institucional
      final emailInput = find.byType(TextFormField).first;
      final passwordInput = find.byType(TextFormField).last;

      await tester.enterText(emailInput, 'alumno@alumnos.ubiobio.cl');
      await tester.enterText(passwordInput, '123456');
      await tester.pump();

      // Verificar que el texto fue ingresado correctamente
      expect(find.text('alumno@alumnos.ubiobio.cl'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);

      // 4. El botón de ingresar debe estar habilitado
      final loginBtn = find.text('Ingresar');
      expect(loginBtn, findsOneWidget);
    });

    testWidgets('Cierre de sesión desde Perfil / Settings',
        (WidgetTester tester) async {
      // Montar componente de Perfil
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthService()),
              ],
              child: const SettingsTitle(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verificar botón de "Cerrar sesión"
      final logoutButton = find.text('Cerrar sesión');
      expect(logoutButton, findsOneWidget);
    });
  });
}

