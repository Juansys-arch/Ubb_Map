import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubb/blocs/gps/gps_bloc.dart';
import 'package:ubb/widgets/gps_acces_content.dart';

class MockGpsBloc extends MockBloc<GpsEvent, GpsState> implements GpsBloc {}

void main() {
  group('GpsAccessContent + GpsBloc - Pruebas de Integración', () {
    late MockGpsBloc mockGpsBloc;
    late StreamController<GpsState> gpsStateController;

    setUp(() {
      mockGpsBloc = MockGpsBloc();
      gpsStateController = StreamController<GpsState>.broadcast();
    });

    tearDown(() {
      gpsStateController.close();
    });

    Widget createWidgetUnderTest(GpsBloc gpsBloc) {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: GpsAccessContent(),
            ),
          ),
        ],
      );

      return BlocProvider<GpsBloc>.value(
        value: gpsBloc,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      );
    }

    testWidgets(
      'El botón "Solicitar acceso" está oculto con GPS inactivo y aparece cuando el estado cambia a GPS activo',
      (WidgetTester tester) async {
        // Estado inicial: GPS desactivado
        var currentState = const GpsState(
          isGpsEnabled: false,
          isGpsPermissionGranted: false,
        );

        when(() => mockGpsBloc.state).thenAnswer((_) => currentState);
        when(() => mockGpsBloc.stream).thenAnswer((_) => gpsStateController.stream);

        await tester.pumpWidget(createWidgetUnderTest(mockGpsBloc));
        await tester.pumpAndSettle();

        // Verificamos que el botón no esté presente
        expect(find.text('Solicitar acceso'), findsNothing);

        // Simulamos que el usuario o el sistema activa el GPS
        currentState = const GpsState(
          isGpsEnabled: true,
          isGpsPermissionGranted: false,
        );
        gpsStateController.add(currentState);

        await tester.pumpAndSettle();

        // Verificamos que el botón 'Solicitar acceso' ahora sí está visible
        expect(find.text('Solicitar acceso'), findsOneWidget);
      },
    );

    testWidgets(
      'Al presionar el botón "Solicitar acceso" se invoca askGpsAccess en el BLoC',
      (WidgetTester tester) async {
        const activeGpsState = GpsState(
          isGpsEnabled: true,
          isGpsPermissionGranted: false,
        );

        when(() => mockGpsBloc.state).thenReturn(activeGpsState);
        when(() => mockGpsBloc.stream).thenAnswer((_) => Stream.value(activeGpsState));
        when(() => mockGpsBloc.askGpsAccess()).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest(mockGpsBloc));
        await tester.pumpAndSettle();

        // Encontramos el botón y lo presionamos
        final botonAcceso = find.text('Solicitar acceso');
        expect(botonAcceso, findsOneWidget);

        await tester.tap(botonAcceso);
        await tester.pumpAndSettle();

        // Verificamos que se haya ejecutado la solicitud de permisos en el BLoC
        verify(() => mockGpsBloc.askGpsAccess()).called(1);
      },
    );
  });
}

