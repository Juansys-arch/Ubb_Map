part of 'map_bloc_lc.dart';

abstract class MapEventLC extends Equatable {
  const MapEventLC();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEventLC extends MapEventLC {
  final GoogleMapController controllerLC;
  const OnMapInitializedEventLC(this.controllerLC);
}

class OnStopFollowingUserEventLC extends MapEventLC {}

class OnStartFollowingUserEventLC extends MapEventLC {}

class UpdateUserPolylineEventLC extends MapEventLC {
  final List<LatLng> userHistoryLocationLC;
  const UpdateUserPolylineEventLC(this.userHistoryLocationLC);
}

class OnToggleUserRouteLC extends MapEventLC {}

class DisplayPolylineEventLC extends MapEventLC {
  final Map<String, Polyline> polylinesLC;
  final Map<String, Marker> markersLC;
  const DisplayPolylineEventLC(this.polylinesLC, this.markersLC);
}

class ToggleMedicalMarkersVisibilityEventLC extends MapEventLC {}

class AddMedicalMarkerEventLC extends MapEventLC {
  final MedicalMarker medicalMarkerLC;

  const AddMedicalMarkerEventLC(this.medicalMarkerLC);

  @override
  List<Object> get props => [medicalMarkerLC];
}
