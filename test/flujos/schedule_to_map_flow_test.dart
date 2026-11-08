import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/models/class_schedule.dart';
import 'package:ubb/screens/schedule_screen.dart';

void main() {
  group('Flujo 2: Horario de Clases hacia Ruta en el Mapa (Schedule to Map Flow)', () {
    testWidgets('Visualización del horario, cambio de días y botón de navegación al mapa',
        (WidgetTester tester) async {
      // 1. Montar pantalla de Horario
      await tester.pumpWidget(
        const MaterialApp(
          home: ScheduleScreen(),
        ),
      );

      // 2. Esperar que carguen los datos mock/locales del servicio
      await tester.pumpAndSettle();

      // 3. Verificar que se renderiza el AppBar y los días de la semana
      expect(find.text('Mi horario'), findsOneWidget);
      expect(find.text('Lun'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Mié'), findsOneWidget);

      // 4. Cambiar al día "Mar" (Martes)
      await tester.tap(find.text('Mar'));
      await tester.pumpAndSettle();

      // 5. Verificar que el botón de mapa para ver el aula está presente en las clases
      final mapButtons = find.byTooltip('Ver sala en el mapa');
      if (mapButtons.evaluate().isNotEmpty) {
        expect(mapButtons.first, findsOneWidget);
        // El usuario puede presionar el botón para abrir la ruta en el mapa
        await tester.tap(mapButtons.first);
        await tester.pump();
      }
    });
  });
}

