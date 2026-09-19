

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:ubb/models/models.dart';

/// Servicio de rutas usando OSRM (Open Source Routing Machine) y Nominatim.
/// Compatible con el servicio de Mapbox anterior: mismos parámetros y tipo de retorno.
/// Completamente gratuito, sin API key, basado en OpenStreetMap.
class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioNominatim;

  /// OSRM peatonal — rutas a pie, gratis y sin token.
  static const String _osrmBaseUrl =
      'https://router.project-osrm.org/route/v1/foot';

  /// Nominatim (OpenStreetMap) — geocodificación inversa, gratis y sin token.
  static const String _nominatimBaseUrl =
      'https://nominatim.openstreetmap.org';

  TrafficService()
      : _dioTraffic = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            // Requerido por la política de uso de Nominatim
            'User-Agent': 'UBBMapApp/1.0 (academic project)',
          },
        )),
        _dioNominatim = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'User-Agent': 'UBBMapApp/1.0 (academic project)',
            'Accept-Language': 'es',
          },
        ));

  /// Obtiene la ruta peatonal desde [start] hasta [end] usando OSRM.
  /// La geometría viene en polyline6, compatible con decodePolyline(..., accuracyExponent: 6).
  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final url =
        '$_osrmBaseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

    final resp = await _dioTraffic.get(url, queryParameters: {
      'overview': 'full',
      'geometries': 'polyline6',
      'steps': 'false',
    });

    return TrafficResponse.fromMap(resp.data);
  }

  /// Geocodificación inversa con Nominatim: devuelve información del punto [coors].
  /// Retorna un [Feature] compatible con el modelo existente de la app.
  Future<Feature> getInformationByCoors(LatLng coors) async {
    final resp = await _dioNominatim.get(
      '$_nominatimBaseUrl/reverse',
      queryParameters: {
        'lat': coors.latitude,
        'lon': coors.longitude,
        'format': 'json',
        'zoom': 17,
      },
    );

    final data = resp.data as Map<String, dynamic>;

    // Convertir respuesta de Nominatim al formato Feature de la app
    final displayName = data['display_name'] as String? ?? '';
    final lon = double.tryParse(data['lon']?.toString() ?? '') ?? coors.longitude;
    final lat = double.tryParse(data['lat']?.toString() ?? '') ?? coors.latitude;

    return Feature(
      id: data['place_id']?.toString() ?? '',
      text: displayName.split(',').first.trim(),
      placeName: [displayName],
      placeType: const ['place'],
      center: [lon, lat],
    );

  }

  /// Búsqueda de lugares por texto con Nominatim.
  /// Retorna una lista de [Feature] para el buscador manual.
  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final resp = await _dioNominatim.get(
      '$_nominatimBaseUrl/search',
      queryParameters: {
        'q': query,
        'format': 'json',
        'limit': 7,
        'lat': proximity.latitude,
        'lon': proximity.longitude,
      },
    );

    final List<dynamic> results = resp.data as List<dynamic>;

    return results.map((item) {
      final map = item as Map<String, dynamic>;
      final displayName = map['display_name'] as String? ?? '';
      final lon = double.tryParse(map['lon']?.toString() ?? '') ?? 0.0;
      final lat = double.tryParse(map['lat']?.toString() ?? '') ?? 0.0;

      return Feature(
        id: map['place_id']?.toString() ?? '',
        text: displayName.split(',').first.trim(),
        placeName: [displayName],
        placeType: [map['type'] as String? ?? 'place'],
        center: [lon, lat],
      );

    }).toList();
  }
}
