part of 'map_bloc_lc.dart';

class MapStateLC extends Equatable {
  final bool isMapInitializedLC;
  final bool isFollowingUserLC;
  final bool showMyRouteLC;
  final bool showMedicalMarkersLC;
  final BitmapDescriptor customMedicalMarkerIconLC;

  final Map<String, Polyline> polylinesLC;
  final Map<String, Marker> markersLC;
  final Map<String, Marker> medicalMarkersLC;

  const MapStateLC({
    this.isMapInitializedLC = false,
    this.isFollowingUserLC = false,
    this.showMyRouteLC = false,
    this.showMedicalMarkersLC = false,
    Map<String, Polyline>? polylinesLC,
    Map<String, Marker>? markersLC,
    Map<String, Marker>? medicalMarkersLC,
    BitmapDescriptor? customMedicalMarkerIconLC,
  })  : polylinesLC = polylinesLC ?? const {},
        medicalMarkersLC = medicalMarkersLC ?? const {},
        markersLC = markersLC ?? const {},
        customMedicalMarkerIconLC =
            customMedicalMarkerIconLC ?? BitmapDescriptor.defaultMarker;

  MapStateLC copyWith(
          {bool? isMapInitializedLC,
          bool? isFollowingUserLC,
          bool? showMyRouteLC,
          bool? showMedicalMarkersLC,
          Map<String, Polyline>? polylinesLC,
          BitmapDescriptor? customMedicalMarkerIconLC,
          Map<String, Marker>? markersLC,
          Map<String, Marker>? medicalMarkersLC}) =>
      MapStateLC(
          isMapInitializedLC: isMapInitializedLC ?? this.isMapInitializedLC,
          isFollowingUserLC: isFollowingUserLC ?? this.isFollowingUserLC,
          showMyRouteLC: showMyRouteLC ?? this.showMyRouteLC,
          polylinesLC: polylinesLC ?? this.polylinesLC,
          showMedicalMarkersLC:
              showMedicalMarkersLC ?? this.showMedicalMarkersLC,
          markersLC: markersLC ?? this.markersLC,
          customMedicalMarkerIconLC:
              customMedicalMarkerIconLC ?? this.customMedicalMarkerIconLC,
          medicalMarkersLC: medicalMarkersLC ?? this.medicalMarkersLC);

  @override
  List<Object> get props => [
        isMapInitializedLC,
        isFollowingUserLC,
        showMyRouteLC,
        polylinesLC,
        medicalMarkersLC,
        showMedicalMarkersLC,
        customMedicalMarkerIconLC
      ];
}
