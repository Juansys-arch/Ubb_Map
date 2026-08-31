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

part 'map_event_fm.dart';
part 'map_state_fm.dart';

class MapBlocFM extends Bloc<MapEventFM, MapStateFM> {
  final LocationBloc locationBlocFM;
  GoogleMapController? _mapControllerFM;
  LatLng? mapCenterFM;

  MapBlocFM({
    required this.locationBlocFM,
  }) : super(const MapStateFM()) {
    on<OnMapInitializedEventFM>(_onInitMapFM);
    on<OnStartFollowingUserEventFM>(_onStartFollowingUserFM);
    on<OnStopFollowingUserEventFM>(
        (event, emit) => emit(state.copyWith(isFollowingUserFM: false)));
    on<UpdateUserPolylineEventFM>(_onPolylineNewPointFM);
    on<OnToggleUserRouteFM>((event, emit) =>
        emit(state.copyWith(showMyRouteFM: !state.showMyRouteFM)));
    on<ToggleMedicalMarkersVisibilityEventFM>((event, emit) {
      final updatedStateFM =
          state.copyWith(showMedicalMarkersFM: !state.showMedicalMarkersFM);
      emit(updatedStateFM);
    });

    on<AddMedicalMarkerEventFM>((event, emit) async {
      final customMedicalMarkerFM =
          await getAssetImageMarker('assets/kit_medical.png');
      final newMarkerFM = Marker(
          markerId: MarkerId(event.medicalMarkerFM.position.toString()),
          position: event.medicalMarkerFM.position,
          icon: customMedicalMarkerFM,
          infoWindow: InfoWindow(title: 'Kit Médico', onTap: () {}));

      final updatedMarkersFM = Map<String, Marker>.from(state.medicalMarkersFM)
        ..[event.medicalMarkerFM.position.toString()] = newMarkerFM;

      emit(state.copyWith(medicalMarkersFM: updatedMarkersFM));
    });

    loadMedicalMarkersFromJson();

    on<DisplayPolylineEventFM>((event, emit) => emit(state.copyWith(
        polylinesFM: event.polylinesFM, markersFM: event.markersFM)));
    locationBlocFM.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEventFM(locationState.myLocationHistory));
      }
      if (!state.isFollowingUserFM) return;
      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  Future<void> loadMedicalMarkersFromJson() async {
    final response = await http.get(Uri.parse(
        'https://ubbmap-app-default-rtdb.firebaseio.com/registros_kitmarker_fm.json'));

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON.
      final jsonList = json.decode(response.body) as List;

      final medicalMarkers =
          jsonList.map((json) => MedicalMarker.fromJson(json)).toList();

      for (final marker in medicalMarkers) {
        add(AddMedicalMarkerEventFM(marker));
      }
    } else {
      // Maneja el error de la solicitud HTTP aquí si es necesario.
      throw Exception('Error al cargar datos desde la URL');
    }
  }

  void _onInitMapFM(OnMapInitializedEventFM event, Emitter<MapStateFM> emit) {
    _mapControllerFM = event.controllerFM;
    _mapControllerFM!.setMapStyle(jsonEncode(natureMapTheme));
    emit(state.copyWith(isMapInitializedFM: true));
  }

  void _onStartFollowingUserFM(
      OnStartFollowingUserEventFM event, Emitter<MapStateFM> emit) {
    emit(state.copyWith(isFollowingUserFM: true));
    if (locationBlocFM.state.lastKnowLocation == null) return;
    moveCamera(locationBlocFM.state.lastKnowLocation!);
  }

  void _onPolylineNewPointFM(
      UpdateUserPolylineEventFM event, Emitter<MapStateFM> emit) {
    final myRouteFM = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userHistoryLocationFM);

    final currentPolylinesFM = Map<String, Polyline>.from(state.polylinesFM);
    currentPolylinesFM['myRoute'] = myRouteFM;

    emit(state.copyWith(polylinesFM: currentPolylinesFM));
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

    Set<Polyline> polylinesFM = {};
    polylinesFM.add(backgroundRoute);
    polylinesFM.add(foregroundRoute);

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

    final currentPolylinesFM = Map<String, Polyline>.from(state.polylinesFM);

    currentPolylinesFM['route_background'] = backgroundRoute;
    currentPolylinesFM['route_foreground'] = foregroundRoute;

    final currentMarker = Map<String, Marker>.from(state.markersFM);
    currentMarker['start'] = startMarker;
    currentMarker['end'] = endMarker;

    add(DisplayPolylineEventFM(currentPolylinesFM, currentMarker));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapControllerFM?.showMarkerInfoWindow(const MarkerId('end'));
  }

  void moveCamera(LatLng target) {
    final cameraPositionFM = CameraPosition(target: target, zoom: 12.0);
    final cameraUpdateFM = CameraUpdate.newCameraPosition(cameraPositionFM);
    _mapControllerFM?.animateCamera(cameraUpdateFM);
  }
}
