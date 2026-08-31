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

part 'map_event_lc.dart';
part 'map_state_lc.dart';

class MapBlocLC extends Bloc<MapEventLC, MapStateLC> {
  final LocationBloc locationBlocLC;
  GoogleMapController? _mapControllerLC;
  LatLng? mapCenterLC;

  MapBlocLC({
    required this.locationBlocLC,
  }) : super(const MapStateLC()) {
    on<OnMapInitializedEventLC>(_onInitMapLC);
    on<OnStartFollowingUserEventLC>(_onStartFollowingUserLC);
    on<OnStopFollowingUserEventLC>(
        (event, emit) => emit(state.copyWith(isFollowingUserLC: false)));
    on<UpdateUserPolylineEventLC>(_onPolylineNewPointLC);
    on<OnToggleUserRouteLC>((event, emit) =>
        emit(state.copyWith(showMyRouteLC: !state.showMyRouteLC)));
    on<ToggleMedicalMarkersVisibilityEventLC>((event, emit) {
      final updatedStateLC =
          state.copyWith(showMedicalMarkersLC: !state.showMedicalMarkersLC);
      emit(updatedStateLC);
    });

    on<AddMedicalMarkerEventLC>((event, emit) async {
      final customMedicalMarkerLC =
          await getAssetImageMarker('assets/kit_medical.png');
      final newMarkerLC = Marker(
          markerId: MarkerId(event.medicalMarkerLC.position.toString()),
          position: event.medicalMarkerLC.position,
          icon: customMedicalMarkerLC,
          infoWindow: InfoWindow(title: 'Kit Médico', onTap: () {}));

      final updatedMarkersLC = Map<String, Marker>.from(state.medicalMarkersLC)
        ..[event.medicalMarkerLC.position.toString()] = newMarkerLC;

      emit(state.copyWith(medicalMarkersLC: updatedMarkersLC));
    });

    loadMedicalMarkersFromJson();

    on<DisplayPolylineEventLC>((event, emit) => emit(state.copyWith(
        polylinesLC: event.polylinesLC, markersLC: event.markersLC)));
    locationBlocLC.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEventLC(locationState.myLocationHistory));
      }
      if (!state.isFollowingUserLC) return;
      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  Future<void> loadMedicalMarkersFromJson() async {
    final response = await http.get(Uri.parse(
        'https://ubbmap-app-default-rtdb.firebaseio.com/registros_kitmarker_lc.json'));

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON.
      final jsonList = json.decode(response.body) as List;

      final medicalMarkers =
          jsonList.map((json) => MedicalMarker.fromJson(json)).toList();

      for (final marker in medicalMarkers) {
        add(AddMedicalMarkerEventLC(marker));
      }
    } else {
      // Maneja el error de la solicitud HTTP aquí si es necesario.
      throw Exception('Error al cargar datos desde la URL');
    }
  }

  void _onInitMapLC(OnMapInitializedEventLC event, Emitter<MapStateLC> emit) {
    _mapControllerLC = event.controllerLC;
    _mapControllerLC!.setMapStyle(jsonEncode(natureMapTheme));
    emit(state.copyWith(isMapInitializedLC: true));
  }

  void _onStartFollowingUserLC(
      OnStartFollowingUserEventLC event, Emitter<MapStateLC> emit) {
    emit(state.copyWith(isFollowingUserLC: true));
    if (locationBlocLC.state.lastKnowLocation == null) return;
    moveCamera(locationBlocLC.state.lastKnowLocation!);
  }

  void _onPolylineNewPointLC(
      UpdateUserPolylineEventLC event, Emitter<MapStateLC> emit) {
    final myRouteLC = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userHistoryLocationLC);

    final currentPolylinesLC = Map<String, Polyline>.from(state.polylinesLC);
    currentPolylinesLC['myRoute'] = myRouteLC;

    emit(state.copyWith(polylinesLC: currentPolylinesLC));
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

    Set<Polyline> polylinesLC = {};
    polylinesLC.add(backgroundRoute);
    polylinesLC.add(foregroundRoute);

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

    final currentPolylinesLC = Map<String, Polyline>.from(state.polylinesLC);

    currentPolylinesLC['route_background'] = backgroundRoute;
    currentPolylinesLC['route_foreground'] = foregroundRoute;

    final currentMarker = Map<String, Marker>.from(state.markersLC);
    currentMarker['start'] = startMarker;
    currentMarker['end'] = endMarker;

    add(DisplayPolylineEventLC(currentPolylinesLC, currentMarker));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapControllerLC?.showMarkerInfoWindow(const MarkerId('end'));
  }

  void moveCamera(LatLng target) {
    final cameraPositionLC = CameraPosition(target: target, zoom: 12.0);
    final cameraUpdateLC = CameraUpdate.newCameraPosition(cameraPositionLC);
    _mapControllerLC?.animateCamera(cameraUpdateLC);
  }
}
