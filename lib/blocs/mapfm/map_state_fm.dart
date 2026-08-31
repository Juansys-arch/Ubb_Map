part of 'map_bloc_fm.dart';

class MapStateFM extends Equatable {
  final bool isMapInitializedFM;
  final bool isFollowingUserFM;
  final bool showMyRouteFM;
  final bool showMedicalMarkersFM;
  final BitmapDescriptor customMedicalMarkerIconFM;

  final Map<String, Polyline> polylinesFM;
  final Map<String, Marker> markersFM;
  final Map<String, Marker> medicalMarkersFM;

  const MapStateFM({
    this.isMapInitializedFM = false,
    this.isFollowingUserFM = false,
    this.showMyRouteFM = false,
    this.showMedicalMarkersFM = false,
    Map<String, Polyline>? polylinesFM,
    Map<String, Marker>? markersFM,
    Map<String, Marker>? medicalMarkersFM,
    BitmapDescriptor? customMedicalMarkerIconFM,
  })  : polylinesFM = polylinesFM ?? const {},
        medicalMarkersFM = medicalMarkersFM ?? const {},
        markersFM = markersFM ?? const {},
        customMedicalMarkerIconFM =
            customMedicalMarkerIconFM ?? BitmapDescriptor.defaultMarker;

  MapStateFM copyWith(
          {bool? isMapInitializedFM,
          bool? isFollowingUserFM,
          bool? showMyRouteFM,
          bool? showMedicalMarkersFM,
          Map<String, Polyline>? polylinesFM,
          BitmapDescriptor? customMedicalMarkerIconFM,
          Map<String, Marker>? markersFM,
          Map<String, Marker>? medicalMarkersFM}) =>
      MapStateFM(
          isMapInitializedFM: isMapInitializedFM ?? this.isMapInitializedFM,
          isFollowingUserFM: isFollowingUserFM ?? this.isFollowingUserFM,
          showMyRouteFM: showMyRouteFM ?? this.showMyRouteFM,
          polylinesFM: polylinesFM ?? this.polylinesFM,
          showMedicalMarkersFM:
              showMedicalMarkersFM ?? this.showMedicalMarkersFM,
          markersFM: markersFM ?? this.markersFM,
          customMedicalMarkerIconFM:
              customMedicalMarkerIconFM ?? this.customMedicalMarkerIconFM,
          medicalMarkersFM: medicalMarkersFM ?? this.medicalMarkersFM);

  @override
  List<Object> get props => [
        isMapInitializedFM,
        isFollowingUserFM,
        showMyRouteFM,
        polylinesFM,
        medicalMarkersFM,
        showMedicalMarkersFM,
        customMedicalMarkerIconFM
      ];
}
