import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/services/services.dart';
import 'package:ubb/widgets/concepcion/search_bar.dart' as ubb_search;

void main() {
  group('Flujo 4: Búsqueda de Destino en el Mapa (Search & Routing Flow)', () {
    testWidgets('Renderizado de la barra de búsqueda y activación del buscador',
        (WidgetTester tester) async {
      final trafficService = TrafficService();
      final locationBloc = LocationBloc();

      // 1. Montar el widget de búsqueda con los Blocs requeridos
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => locationBloc),
                BlocProvider(create: (_) => SearchBloc(trafficService: trafficService)),
                BlocProvider(create: (_) => MapBloc(locationBloc: locationBloc)),
              ],
              child: const Stack(
                children: [
                  ubb_search.SearchBar(),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 2. Verificar que se renderiza el botón de buscar
      final searchTrigger = find.text('Buscar...');
      expect(searchTrigger, findsOneWidget);

      // 3. Verificar presencia del botón atrás junto al buscador
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });
}

