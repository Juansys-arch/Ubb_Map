import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/helpers/helpers.dart';
import 'package:ubb/models/models.dart';
import 'package:ubb/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  MapBloc({
    required this.locationBloc,
  }) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));
    on<ToggleMedicalMarkersVisibilityEvent>((event, emit) {
      final updatedState =
          state.copyWith(showMedicalMarkers: !state.showMedicalMarkers);
      emit(updatedState);
    });

    on<AddMedicalMarkerEvent>((event, emit) async {
      final customMedicalMarker =
          await getAssetImageMarker('assets/kit_medical.png');
      final newMarker = Marker(
          markerId: MarkerId(event.medicalMarker.position.toString()),
          position: event.medicalMarker.position,
          icon: customMedicalMarker,
          infoWindow: InfoWindow(title: 'Kit Médico', onTap: () {}));

      final updatedMarkers = Map<String, Marker>.from(state.medicalMarkers)
        ..[event.medicalMarker.position.toString()] = newMarker;

      emit(state.copyWith(medicalMarkers: updatedMarkers));
    });

    loadMedicalMarkersFromJson();

    on<DisplayPolylineEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!state.isFollowingUser) return;
      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  Future<void> loadMedicalMarkersFromJson() async {
    try {
      final response = await http.get(Uri.parse(
          'https://ubbmap-94203-default-rtdb.firebaseio.com/registros_kitmarker_ccp.json'));

      if (response.statusCode == 200 && response.body != 'null') {
        final dynamic decoded = json.decode(response.body);

        List<MedicalMarker> medicalMarkers = [];

        if (decoded is List) {
          medicalMarkers = decoded
              .where((item) => item != null)
              .map((json) => MedicalMarker.fromJson(json))
              .toList();
        } else if (decoded is Map) {
          medicalMarkers = decoded.values
              .where((item) => item != null)
              .map((json) =>
                  MedicalMarker.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }

        for (final marker in medicalMarkers) {
          add(AddMedicalMarkerEvent(marker));
        }
      }
    } catch (_) {
      // Evita romper el bloc si el nodo aún no existe en Firebase
    }
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(natureMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;
    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userHistoryLocation);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    Polyline backgroundRoute = Polyline(
      jointType: JointType.round,
      geodesic: true,
      color: const Color(0xff0A2861).withOpacity(0.6),
      polylineId: const PolylineId('route_background'),
      width: 9,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    Polyline foregroundRoute = Polyline(
      jointType: JointType.round,
      geodesic: true,
      color: const Color(0xff0A2861),
      polylineId: const PolylineId('route_foreground'),
      width: 4,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final startMarkerPin = await getAssetImageMarker('assets/pin.png');
    final endMarkerPin = await getAssetImageMarker('assets/pin.png');

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMarkerPin,
      infoWindow: const InfoWindow(
        title: 'Esta es tu posición actual!',
      ),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMarkerPin,
      infoWindow: const InfoWindow(
        title: 'Este es tu destino!',
      ),
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route_background'] = backgroundRoute;
    currentPolylines['route_foreground'] = foregroundRoute;

    final currentMarker = Map<String, Marker>.from(state.markers);
    currentMarker['start'] = startMarker;
    currentMarker['end'] = endMarker;

    add(DisplayPolylineEvent(currentPolylines, currentMarker));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId('end'));
  }

  void moveCamera(LatLng target) {
    final cameraPosition = CameraPosition(target: target, zoom: 12.0);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    _mapController?.animateCamera(cameraUpdate);
  }
}