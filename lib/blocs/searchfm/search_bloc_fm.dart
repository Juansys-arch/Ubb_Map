import 'package:firebase_database/firebase_database.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:ubb/models/models.dart';
import 'package:ubb/services/services.dart';

part 'search_event_fm.dart';
part 'search_state_fm.dart';

class SearchBlocFM extends Bloc<SearchEventFM, SearchStateFM> {
  TrafficService trafficService;

  SearchBlocFM({
    required this.trafficService,
  }) : super(const SearchStateFM()) {
    on<OnActivateManualMarkerEventFM>(
        (event, emit) => emit(state.copyWith(displayManualMarkerFM: true)));
    on<OnDeactivateManualMarkerEventFM>(
        (event, emit) => emit(state.copyWith(displayManualMarkerFM: false)));
    on<OnNewPlacesFoundEventFM>(
        (event, emit) => emit(state.copyWith(placesFM: event.placesFM)));
    on<AddToHistoryEventFM>((event, emit) =>
        emit(state.copyWith(historyFM: [event.placeFM, ...state.historyFM])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final endPlace = await trafficService.getInformationByCoors(end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coor) => LatLng(
              coor[0].toDouble(),
              coor[1].toDouble(),
            ))
        .toList();

    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endPlace: endPlace,
    );
  }

  Future<List<Feature>> loadPlacesFromJsonFM() async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference reference = database.ref().child('registros_fm');

    List<Feature> places = [];

    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.value != null) {
        if (snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            Feature place = Feature.fromMap(Map<String, dynamic>.from(value));
            places.add(place);
          });
        } else if (snapshot.value is List<dynamic>) {
          List<dynamic> values = snapshot.value as List<dynamic>;
          for (var value in values) {
            Feature place = Feature.fromMap(Map<String, dynamic>.from(value));
            places.add(place);
          }
        }
      }

      return places;
    } catch (error) {
      throw Exception('Error al cargar datos desde Firebase');
    }
  }

  String normalizeText(String text) {
    const accentsMap = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'ñ': 'n',
      'Ñ': 'N'
    };

    return text
        .split('')
        .map((char) => accentsMap[char] ?? char)
        .join()
        .toLowerCase();
  }

  Future<List<Feature>> getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = <Feature>[];

    final normalizedQuery = normalizeText(query);

    final places = await loadPlacesFromJsonFM();

    final match = RegExp(r'\d+([a-zA-Z]+)').firstMatch(query);

    if (match != null) {
      final queryLetters = normalizeText(match.group(1) ?? '');

      final filteredPlaces = places
          .where((place) => place.placeName.any((name) =>
              normalizeText(name.replaceAll(RegExp('[^a-zA-Z]+'), '')) ==
              queryLetters))
          .toList();

      newPlaces.addAll(filteredPlaces);
      add(OnNewPlacesFoundEventFM(filteredPlaces));
    } else {
      final filteredPlaces = places
          .where((place) => normalizeText(place.text).contains(normalizedQuery))
          .toList();

      newPlaces.addAll(filteredPlaces);
      add(OnNewPlacesFoundEventFM(filteredPlaces));
    }

    return newPlaces;
  }
}
