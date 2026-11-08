import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/models/building_info.dart';
import 'package:ubb/screens/building_info_screen.dart';

void main() {
  group('Flujo 3: Guía de Edificios y FAQ hacia el Mapa (Building Info Flow)', () {
    testWidgets('Búsqueda por texto, filtrado de categorías y desplegable de trámites',
        (WidgetTester tester) async {
      // 1. Montar pantalla de Guía de Edificios
      await tester.pumpWidget(
        const MaterialApp(
          home: BuildingInfoScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 2. Verificar cabecera y lista de edificios inicial
      expect(find.text('Guía de Edificios UBB'), findsOneWidget);
      expect(find.text('Rectoría UBB'), findsOneWidget);

      // 3. Filtrar usando el campo de búsqueda por "Finanzas"
      final searchInput = find.byType(TextField);
      expect(searchInput, findsOneWidget);

      await tester.enterText(searchInput, 'Finanzas');
      await tester.pumpAndSettle();

      // Verificar que el resultado de Finanzas sigue visible y Rectoría se ocultó por el filtro
      expect(find.text('Dirección de Finanzas y Cobranzas'), findsOneWidget);
      expect(find.text('Rectoría UBB'), findsNothing);

      // 4. Limpiar búsqueda
      await tester.enterText(searchInput, '');
      await tester.pumpAndSettle();
      expect(find.text('Rectoría UBB'), findsOneWidget);

      // 5. Desplegar sección de preguntas frecuentes y trámites en el primer edificio
      final faqExpandButton = find.text('Dudas y trámites').first;
      await tester.tap(faqExpandButton);
      await tester.pumpAndSettle();

      // Verificar que se desplegaron los trámites y dudas
      expect(find.text('Trámites principales que se realizan:'), findsOneWidget);
      expect(find.text('Dudas frecuentes:'), findsOneWidget);

      // 6. Verificar presencia del botón para ir al mapa
      final goToMapButton = find.text('Ver en mapa').first;
      expect(goToMapButton, findsOneWidget);
    });
  });
}

