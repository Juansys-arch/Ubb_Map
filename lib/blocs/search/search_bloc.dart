import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:ubb/models/models.dart';
import 'package:ubb/services/services.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

import 'package:firebase_database/firebase_database.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));
    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));
    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
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

  Future<List<Feature>> loadPlacesFromJsonCCP() async {
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://ubbmap-app-default-rtdb.firebaseio.com",
    );

    final reference = database.ref().child('registros_ccp');

    List<Feature> places = [];

    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.value != null) {
        if (snapshot.value is Map) {
          final values = Map<String, dynamic>.from(snapshot.value as Map);

          values.forEach((key, value) {
            final place = Feature.fromMap(Map<String, dynamic>.from(value));
            places.add(place);
          });
        } else if (snapshot.value is List) {
          final values = snapshot.value as List;

          for (var value in values) {
            if (value != null) {
              final place = Feature.fromMap(Map<String, dynamic>.from(value));
              places.add(place);
            }
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

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = <Feature>[];

    final normalizedQuery = normalizeText(query);

    final places = await loadPlacesFromJsonCCP();

    final match = RegExp(r'\d+([a-zA-Z]+)').firstMatch(query);

    if (match != null) {
      final queryLetters = normalizeText(match.group(1) ?? '');

      final filteredPlaces = places
          .where((place) => place.placeName.any((name) =>
              normalizeText(name.replaceAll(RegExp('[^a-zA-Z]+'), '')) ==
              queryLetters))
          .toList();

      newPlaces.addAll(filteredPlaces);
      add(OnNewPlacesFoundEvent(filteredPlaces));
    } else {
      final filteredPlaces = places
          .where((place) => normalizeText(place.text).contains(normalizedQuery))
          .toList();

      newPlaces.addAll(filteredPlaces);
      add(OnNewPlacesFoundEvent(filteredPlaces));
    }
  }
}
