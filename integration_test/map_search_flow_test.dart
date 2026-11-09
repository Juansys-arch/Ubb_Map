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
    'Flujo 4: búsqueda de destino desde la navegación del mapa',
    (tester) async {
      final router = createIntegrationRouter(
        scheduleService: ScheduleService(
          userId: '',
          apiService: createTestApiService(),
        ),
      );

      await tester.pumpWidget(IntegrationTestApp(router: router));
      router.go('/map_search');
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Buscar destino'), findsOneWidget);
      expect(find.text('¿Dónde quieres ir?'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

      await tester.tap(find.text('¿Dónde quieres ir?'));
      await tester.pumpAndSettle();
      await pauseForDemo();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      expect(find.text('Buscar...'), findsOneWidget);
      await tester.enterText(searchField, 'Finanzas');
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Edificio de Finanzas'), findsOneWidget);
      expect(find.text('Campus Concepción'), findsOneWidget);
      await tester.tap(find.text('Edificio de Finanzas'));
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Mapa del campus'), findsOneWidget);
      expect(find.text('Edificio de Finanzas'), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await pauseForDemo();
      expect(find.text('Buscar destino'), findsOneWidget);
    },
  );
}
