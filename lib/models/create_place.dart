import 'package:ubb/models/places_model.dart';

Feature createCustomPlace(
  String id,
  String name,
  String placeName,
  List<double> coordinates,
) {
  return Feature(
    id: id,
    placeType: ['building'],
    text: name,
    placeName: [placeName], 
    center: coordinates,
  );
}
