import 'dart:convert';

class PlacesResponse {
  PlacesResponse({
    required this.type,
    required this.features,
    required this.attribution,
  });

  final String type;
  final List<Feature> features;
  final String attribution;

  factory PlacesResponse.fromJson(String str) =>
      PlacesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlacesResponse.fromMap(Map<String, dynamic> json) {
    return PlacesResponse(
      type: json["type"] ?? "", // Provide a default empty string if 'type' is null
      features: List<Feature>.from((json["features"] as List<dynamic>? ?? []).map((x) => Feature.fromMap(x))),
      attribution: json["attribution"] ?? "", // Provide a default empty string if 'attribution' is null
    );
  }

  Map<String, dynamic> toMap() => {
    "type": type,
    "features": List<dynamic>.from(features.map((x) => x.toMap())),
    "attribution": attribution,
  };
}

class Feature {
  Feature({
    required this.id,
    required this.placeType,
    required this.text,
    required this.placeName,
    required this.center,
    this.facultad,
    this.carreras,
    this.imagen,
  });

  final String id;
  final List<String> placeType;
  final String text;
  final List<String> placeName;
  final List<double> center;
  final String? facultad;
  final List<String>? carreras;
  final String? imagen;

  factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"]?.toString() ?? "",
        placeType: List<String>.from(
            json["placetype"]?.map((x) => x.toString()) ?? []),
        text: json["text"]?.toString() ?? "",
        placeName: List<String>.from(
            json["placeName"]?.map((x) => x.toString()) ?? []),
        center: List<double>.from(
            json["center"]?.map((x) => (x as num).toDouble()) ?? []),
        facultad: json["facultad"]?.toString(),
        carreras: json["carreras"] is List
            ? List<String>.from(
                (json["carreras"] as List).map((x) => x.toString()))
            : null,
        imagen: json["imagen"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "placetype": List<dynamic>.from(placeType.map((x) => x)),
    "text": text,
    "placeName": placeName,
    "center": List<dynamic>.from(center.map((x) => x)),
    "facultad": facultad,
    "carreras": carreras,
    "imagen": imagen,
  };

  @override
  String toString() {
    return 'Feature: $text';
  }
}
