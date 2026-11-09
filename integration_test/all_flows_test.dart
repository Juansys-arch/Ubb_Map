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

  testWidgets('Demostración completa de los 4 flujos UBBMap', (tester) async {
    final user = await loginMongoTestUser();
    final router = createIntegrationRouter(
      scheduleService: ScheduleService(
        userId: user.uid,
        apiService: createTestApiService(),
      ),
    );

    await tester.pumpWidget(IntegrationTestApp(router: router));
    router.go('/login');
    await tester.pumpAndSettle();

    // Flujo 1: una persona abre la aplicación y completa el login.
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
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
    expect(find.text('Sesión MongoDB activa'), findsOneWidget);
    await pauseForDemo();

    // Flujo 2: horario y navegación a la sala en el mapa.
    router.go('/schedule');
    await tester.pumpAndSettle();
    expect(find.text('Mi horario'), findsOneWidget);
    final mapButton = find.byTooltip('Ver sala en el mapa');
    for (final day in const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie']) {
      await tester.tap(find.text(day));
      await tester.pumpAndSettle();
      await pauseForDemo();
      if (mapButton.evaluate().isNotEmpty) break;
    }
    expect(mapButton, findsOneWidget);
    await tester.ensureVisible(mapButton);
    await tester.pumpAndSettle();
    await pauseForDemo();
    await tester.tap(mapButton);
    await tester.pumpAndSettle();
    expect(find.text('Mapa del campus'), findsOneWidget);
    expect(find.text('Buscar sala o edificio'), findsOneWidget);
    expect(find.textContaining('·'), findsOneWidget);
    await pauseForDemo();

    // Flujo 3: guía de edificios, búsqueda y FAQ.
    router.go('/building_info');
    await tester.pumpAndSettle();
    expect(find.text('Guía de Edificios UBB'), findsOneWidget);
    await pauseForDemo();
    final buildingSearch = find.byType(TextField);
    await tester.enterText(buildingSearch, 'Finanzas');
    await tester.pumpAndSettle();
    expect(find.text('Dirección de Finanzas y Cobranzas'), findsOneWidget);
    await pauseForDemo();
    final detailsButton =
        find.widgetWithText(OutlinedButton, 'Dudas y trámites');
    expect(detailsButton, findsOneWidget);
    await tester.ensureVisible(detailsButton);
    await tester.pumpAndSettle();
    await tester.tap(detailsButton);
    await tester.pumpAndSettle();
    expect(find.text('Trámites principales que se realizan:'), findsOneWidget);
    await pauseForDemo();
    final financeMapButton = find.widgetWithText(ElevatedButton, 'Ver en mapa');
    expect(financeMapButton, findsOneWidget);
    await tester.ensureVisible(financeMapButton);
    await tester.pumpAndSettle();
    await tester.tap(financeMapButton);
    await tester.pumpAndSettle();
    expect(find.text('Mapa del campus'), findsOneWidget);
    expect(find.text('Finanzas'), findsOneWidget);
    await pauseForDemo();

    // Flujo 4: búsqueda de destino en el mapa.
    router.go('/map_search');
    await tester.pumpAndSettle();
    expect(find.text('Buscar destino'), findsOneWidget);
    expect(find.text('¿Dónde quieres ir?'), findsOneWidget);
    await tester.tap(find.text('¿Dónde quieres ir?'));
    await tester.pumpAndSettle();
    expect(find.text('Buscar...'), findsOneWidget);
    final destinationSearch = find.byType(TextField);
    await tester.enterText(destinationSearch, 'Finanzas');
    await tester.pumpAndSettle();
    expect(find.text('Edificio de Finanzas'), findsOneWidget);
    await tester.tap(find.text('Edificio de Finanzas'));
    await tester.pumpAndSettle();
    expect(find.text('Mapa del campus'), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);
    await pauseForDemo();
  });
}
