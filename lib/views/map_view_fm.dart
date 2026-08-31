import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/bloc.dart';

class MapViewFM extends StatefulWidget {
  final Set<Polyline> polylinesFM;
  final Set<Marker> markersFM;

  const MapViewFM({
    super.key,
    required this.polylinesFM,
    required this.markersFM,
  });

  @override
  MapViewStateFM createState() => MapViewStateFM();
}

class MapViewStateFM extends State<MapViewFM> {
  @override
  Widget build(BuildContext context) {
    final mapBlocFM = BlocProvider.of<MapBlocFM>(context);

    const CameraPosition initialCameraPositionFM = CameraPosition(
      target: LatLng(-36.599603676831755, -72.07553123700048),
      zoom: 18,
    );

    CameraTargetBounds cameraTargetBoundsFM = CameraTargetBounds(
      LatLngBounds(
        southwest: const LatLng(-36.60434735602082, -72.08026864716246),
        northeast: const LatLng(-36.59796234530989, -72.07160313030519),
      ),
    );

    final size = MediaQuery.of(context).size;

    final allMarkersFM = {
      ...widget.markersFM,
      ...mapBlocFM.state.medicalMarkersFM.values,
    };

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (_) => mapBlocFM.add(OnStopFollowingUserEventFM()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPositionFM,
          cameraTargetBounds: cameraTargetBoundsFM,
          compassEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          polylines: widget.polylinesFM,
          zoomGesturesEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference(17.0, 20.0),
          markers: mapBlocFM.state.showMedicalMarkersFM
              ? Set<Marker>.from(allMarkersFM)
              : Set<Marker>.from(widget.markersFM),
          rotateGesturesEnabled: true,
          onMapCreated: (controller) =>
              mapBlocFM.add(OnMapInitializedEventFM(controller)),
          onCameraMove: (position) => mapBlocFM.mapCenterFM = position.target,
        ),
      ),
    );
  }
}
