import 'dart:convert';

/// Respuesta de la API de rutas (compatible con OSRM y Mapbox).
class TrafficResponse {
  final List<Route> routes;
  final List<Waypoint> waypoints;
  final String code;
  final String uuid;

  TrafficResponse({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  factory TrafficResponse.fromJson(String str) =>
      TrafficResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrafficResponse.fromMap(Map<String, dynamic> json) => TrafficResponse(
        routes: List<Route>.from(
            (json['routes'] as List).map((x) => Route.fromMap(x))),
        waypoints: json['waypoints'] != null
            ? List<Waypoint>.from(
                (json['waypoints'] as List).map((x) => Waypoint.fromMap(x)))
            : [],
        // OSRM devuelve "code": "Ok", Mapbox devuelve un string diferente
        code: json['code']?.toString() ?? 'Ok',
        // uuid solo existe en Mapbox; OSRM no lo tiene
        uuid: json['uuid']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'routes': List<dynamic>.from(routes.map((x) => x.toMap())),
        'waypoints': List<dynamic>.from(waypoints.map((x) => x.toMap())),
        'code': code,
        'uuid': uuid,
      };
}

class Route {
  final String weightName;
  final double weight;
  final double duration;
  final double distance;
  final List<Leg> legs;
  final String geometry;

  Route({
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  factory Route.fromJson(String str) => Route.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Route.fromMap(Map<String, dynamic> json) => Route(
        // OSRM no tiene weight_name, usamos fallback
        weightName: json['weight_name']?.toString() ?? 'duration',
        // OSRM no tiene weight separado, usamos duration como fallback
        weight: (json['weight'] ?? json['duration'] ?? 0).toDouble(),
        duration: (json['duration'] ?? 0).toDouble(),
        distance: (json['distance'] ?? 0).toDouble(),
        legs: json['legs'] != null
            ? List<Leg>.from((json['legs'] as List).map((x) => Leg.fromMap(x)))
            : [],
        geometry: json['geometry']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'weight_name': weightName,
        'weight': weight,
        'duration': duration,
        'distance': distance,
        'legs': List<dynamic>.from(legs.map((x) => x.toMap())),
        'geometry': geometry,
      };
}

class Leg {
  final List<dynamic> viaWaypoints;
  final List<Admin> admins;
  final double weight;
  final double duration;
  final List<dynamic> steps;
  final double distance;
  final String summary;

  Leg({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  factory Leg.fromJson(String str) => Leg.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Leg.fromMap(Map<String, dynamic> json) => Leg(
        viaWaypoints: json['via_waypoints'] != null
            ? List<dynamic>.from((json['via_waypoints'] as List))
            : [],
        // OSRM no tiene admins
        admins: json['admins'] != null
            ? List<Admin>.from(
                (json['admins'] as List).map((x) => Admin.fromMap(x)))
            : [],
        weight: (json['weight'] ?? json['duration'] ?? 0).toDouble(),
        duration: (json['duration'] ?? 0).toDouble(),
        steps: json['steps'] != null
            ? List<dynamic>.from((json['steps'] as List))
            : [],
        distance: (json['distance'] ?? 0).toDouble(),
        summary: json['summary']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'via_waypoints': List<dynamic>.from(viaWaypoints),
        'admins': List<dynamic>.from(admins.map((x) => x.toMap())),
        'weight': weight,
        'duration': duration,
        'steps': List<dynamic>.from(steps),
        'distance': distance,
        'summary': summary,
      };
}

class Admin {
  final String iso31661Alpha3;
  final String iso31661;

  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  factory Admin.fromJson(String str) => Admin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Admin.fromMap(Map<String, dynamic> json) => Admin(
        iso31661Alpha3: json['iso_3166_1_alpha3']?.toString() ?? '',
        iso31661: json['iso_3166_1']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'iso_3166_1_alpha3': iso31661Alpha3,
        'iso_3166_1': iso31661,
      };
}

class Waypoint {
  final double distance;
  final String name;
  final List<double> location;

  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  factory Waypoint.fromJson(String str) => Waypoint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Waypoint.fromMap(Map<String, dynamic> json) => Waypoint(
        distance: (json['distance'] ?? 0).toDouble(),
        name: json['name']?.toString() ?? '',
        location: json['location'] != null
            ? List<double>.from(
                (json['location'] as List).map((x) => x.toDouble()))
            : [],
      );

  Map<String, dynamic> toMap() => {
        'distance': distance,
        'name': name,
        'location': List<dynamic>.from(location),
      };
}
