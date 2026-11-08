import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/models/places_model.dart';
import 'package:ubb/services/traffic_service.dart';

void main() {
  group('TrafficService + Nominatim + Feature - Pruebas de Integración (Red Real)', () {
    late TrafficService trafficService;

    setUp(() {
      trafficService = TrafficService();
    });

    test(
      'Obtiene geocodificación inversa real de Nominatim para Campus Fernando May (UBB)',
      () async {
        // Coordenadas del Campus Fernando May de la Universidad del Bío-Bío (Chillán)
        const campusFernandoMayCoors = LatLng(-36.5986, -72.0833);

        try {
          final Feature feature = await trafficService
              .getInformationByCoors(campusFernandoMayCoors)
              .timeout(const Duration(seconds: 30));

          // Verificaciones sobre el Feature devuelto
          expect(feature.id, isNotEmpty);
          expect(feature.text, isNotEmpty);
          expect(feature.placeName, isNotEmpty);
          expect(feature.placeName.first, isNotEmpty);
          expect(feature.center, isNotEmpty);
          expect(feature.center.length, equals(2));

          // Coordenadas aproximadas devueltas
          expect(feature.center[0], closeTo(campusFernandoMayCoors.longitude, 0.05));
          expect(feature.center[1], closeTo(campusFernandoMayCoors.latitude, 0.05));
        } on DioException catch (e) {
          // Si el entorno local no tiene salida a internet para Nominatim
          if (e.error is SocketException || e.type == DioExceptionType.connectionTimeout) {
            printOnFailure('Sin conexión a internet para consultar Nominatim: ${e.message}');
            return;
          }
          rethrow;
        } on SocketException catch (e) {
          printOnFailure('Sin conexión a internet: $e');
        }
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}

