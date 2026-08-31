part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent(this.controller);
}

class OnStopFollowingUserEvent extends MapEvent {}

class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userHistoryLocation;
  const UpdateUserPolylineEvent(this.userHistoryLocation);
}

class OnToggleUserRoute extends MapEvent {}

class DisplayPolylineEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  const DisplayPolylineEvent(this.polylines, this.markers);
}

class ToggleMedicalMarkersVisibilityEvent extends MapEvent {}

class AddMedicalMarkerEvent extends MapEvent {
  final MedicalMarker medicalMarker;

  const AddMedicalMarkerEvent(this.medicalMarker);

  @override
  List<Object> get props => [medicalMarker];
}
