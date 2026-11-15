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
    'Flujo 2: horario y navegación a sala en el mapa',
    (tester) async {
      final user = await loginMongoTestUser();
      final router = createIntegrationRouter(
        scheduleService: ScheduleService(
          userId: user.uid,
          apiService: createTestApiService(),
        ),
      );

      await tester.pumpWidget(IntegrationTestApp(router: router));
      router.go('/schedule');
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Mi horario'), findsOneWidget);
      expect(find.text('Lun'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Mié'), findsOneWidget);
      expect(find.text('Jue'), findsOneWidget);
      expect(find.text('Vie'), findsOneWidget);

      Finder mapButton = find.byTooltip('Ver sala en el mapa');
      for (final day in const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie']) {
        await tester.tap(find.text(day));
        await tester.pumpAndSettle();
        await pauseForDemo();
        if (mapButton.evaluate().isNotEmpty) break;
      }
      expect(mapButton, findsOneWidget);
      await tester.ensureVisible(mapButton);
      await tester.pumpAndSettle();
      await tester.tap(mapButton);
      await tester.pumpAndSettle();
      await pauseForDemo();

      expect(find.text('Mapa del campus'), findsOneWidget);
      expect(find.text('Buscar sala o edificio'), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await pauseForDemo();
      expect(find.text('Mi horario'), findsOneWidget);
    },
  );
}
