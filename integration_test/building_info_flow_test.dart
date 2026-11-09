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

  testWidgets(
    'Flujo 3: búsqueda y FAQ de la guía de edificios',
    (tester) async {
      final router = createIntegrationRouter(
        scheduleService: ScheduleService(
          userId: '',
          apiService: createTestApiService(),
        ),
      );

      await tester.pumpWidget(IntegrationTestApp(router: router));
      router.go('/building_info');
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Guía de Edificios UBB'), findsOneWidget);
      expect(find.text('Rectoría UBB'), findsOneWidget);
      expect(find.text('Dudas frecuentes y ubicación de zonas clave'),
          findsOneWidget);
      expect(find.text('Administración'), findsOneWidget);
      expect(find.text('Finanzas'), findsOneWidget);

      final searchInput = find.byType(TextField);
      expect(searchInput, findsOneWidget);
      await tester.tap(searchInput);
      await tester.enterText(searchInput, 'Finanzas');
      await tester.pumpAndSettle();
      await pauseForDemo();
      expect(find.text('Dirección de Finanzas y Cobranzas'), findsOneWidget);
      expect(find.text('Aranceles y Pagos'), findsOneWidget);

      final detailsButton =
          find.widgetWithText(OutlinedButton, 'Dudas y trámites');
      expect(detailsButton, findsOneWidget);
      await tester.ensureVisible(detailsButton);
      await tester.pumpAndSettle();
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(
          find.text('Trámites principales que se realizan:'), findsOneWidget);
      expect(find.text('Dudas frecuentes:'), findsOneWidget);
      expect(
        find.text('Pago presencial de aranceles y cuotas de matrícula'),
        findsOneWidget,
      );
      expect(find.text('Ver en mapa'), findsOneWidget);

      final mapButton = find.widgetWithText(ElevatedButton, 'Ver en mapa');
      expect(mapButton, findsOneWidget);
      await tester.ensureVisible(mapButton);
      await tester.pumpAndSettle();
      await tester.tap(mapButton);
      await tester.pumpAndSettle();
      await pauseForDemo();
      expect(find.text('Mapa del campus'), findsOneWidget);
      expect(find.text('Finanzas'), findsOneWidget);
    },
  );
}
