part of 'map_bloc_fm.dart';

abstract class MapEventFM extends Equatable {
  const MapEventFM();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEventFM extends MapEventFM {
  final GoogleMapController controllerFM;
  const OnMapInitializedEventFM(this.controllerFM);
}

class OnStopFollowingUserEventFM extends MapEventFM {}

class OnStartFollowingUserEventFM extends MapEventFM {}

class UpdateUserPolylineEventFM extends MapEventFM {
  final List<LatLng> userHistoryLocationFM;
  const UpdateUserPolylineEventFM(this.userHistoryLocationFM);
}

class OnToggleUserRouteFM extends MapEventFM {}

class DisplayPolylineEventFM extends MapEventFM {
  final Map<String, Polyline> polylinesFM;
  final Map<String, Marker> markersFM;
  const DisplayPolylineEventFM(this.polylinesFM, this.markersFM);
}

class ToggleMedicalMarkersVisibilityEventFM extends MapEventFM {}

class AddMedicalMarkerEventFM extends MapEventFM {
  final MedicalMarker medicalMarkerFM;

  const AddMedicalMarkerEventFM(this.medicalMarkerFM);

  @override
  List<Object> get props => [medicalMarkerFM];
}
