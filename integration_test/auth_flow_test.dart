import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ubb/services/schedule_service.dart';

import 'integration_app.dart';
import 'test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeIntegrationTest(initializeFirebase: false);
    await loginMongoTestUser();
  });

  testWidgets('Flujo 1: inicio autenticado y acceso a los módulos',
      (tester) async {
    final user = await loginMongoTestUser();
    final router = createIntegrationRouter(
      scheduleService: ScheduleService(
        userId: user.uid,
        apiService: createTestApiService(),
      ),
    );

    await tester.pumpWidget(IntegrationTestApp(router: router));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    await pauseForDemo();
    await tester.enterText(
      find.byType(TextField).at(0),
      const String.fromEnvironment(
        'TEST_EMAIL',
        defaultValue: 'test.qa@alumnos.ubiobio.cl',
      ),
    );
    await pauseForDemo();
    await tester.enterText(
      find.byType(TextField).at(1),
      const String.fromEnvironment(
        'TEST_PASSWORD',
        defaultValue: 'PasswordQA2026',
      ),
    );
    await pauseForDemo();
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    await pauseForDemo();

    expect(user.uid, isNotEmpty);
    expect(find.text('Sesión MongoDB activa'), findsOneWidget);
    expect(find.text('Ver horario'), findsOneWidget);
    expect(find.text('Guía de edificios'), findsOneWidget);
    expect(find.text('Buscar destino en el mapa'), findsOneWidget);

    await tester.tap(find.text('Guía de edificios'));
    await tester.pumpAndSettle();
    await pauseForDemo();
    expect(find.text('Guía de Edificios UBB'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await pauseForDemo();
    expect(find.text('Sesión MongoDB activa'), findsOneWidget);
  });
}
