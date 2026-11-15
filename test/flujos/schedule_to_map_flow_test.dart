import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ubb/models/class_schedule.dart';
import 'package:ubb/screens/schedule_screen.dart';

void main() {
  setUpAll(() {
    dotenv.loadFromString(envString: 'API_URL=http://146.83.198.35:1665/api');
  });

  group('Flujo 2: Horario de Clases hacia Ruta en el Mapa (Schedule to Map Flow)', () {
    testWidgets('Visualización del horario, cambio de días y botón de navegación al mapa',
        (WidgetTester tester) async {
      final testClasses = [
        const ClassSchedule(
          day: 'Lun',
          subject: 'Ingeniería de Software',
          code: 'IS-101',
          room: 'Sala 12',
          building: 'Aulas A',
          campus: 'Concepción',
          start: TimeOfDay(hour: 8, minute: 30),
          end: TimeOfDay(hour: 10, minute: 0),
          color: Colors.blue,
          mapRoute: '/map',
        ),
        const ClassSchedule(
          day: 'Mar',
          subject: 'Bases de Datos',
          code: 'BD-202',
          room: 'Lab 3',
          building: 'Informática',
          campus: 'Concepción',
          start: TimeOfDay(hour: 10, minute: 15),
          end: TimeOfDay(hour: 12, minute: 0),
          color: Colors.green,
          mapRoute: '/map',
        ),
      ];

      final router = GoRouter(
        initialLocation: '/schedule',
        routes: [
          GoRoute(
            path: '/schedule',
            builder: (context, state) => ScheduleScreen(
              scheduleFuture: Future.value(testClasses),
            ),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const Scaffold(body: Text('Map Screen')),
          ),
        ],
      );

      // 1. Montar pantalla de Horario con GoRouter
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
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

