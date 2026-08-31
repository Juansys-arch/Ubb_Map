import 'package:google_maps_flutter/google_maps_flutter.dart';

class MedicalMarker {
  LatLng position;
  String title;
  String description;

  MedicalMarker({
    required this.position,
    required this.title,
    required this.description,
  });

  factory MedicalMarker.fromJson(Map<String, dynamic> json) {
    final latitude = json["latitude"];
    final longitude = json["longitude"];
    final title = json["title"];
    final description = json["description"];
    final position = LatLng(latitude, longitude);

    return MedicalMarker(
      position: position,
      title: title,
      description: description,
    );
  }
}
