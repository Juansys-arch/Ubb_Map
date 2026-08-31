import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/bloc.dart';

class MapViewLC extends StatefulWidget {
  final Set<Polyline> polylinesLC;
  final Set<Marker> markersLC;

  const MapViewLC({
    super.key,
    required this.polylinesLC,
    required this.markersLC,
  });

  @override
  MapViewStateLC createState() => MapViewStateLC();
}

class MapViewStateLC extends State<MapViewLC> {
  @override
  Widget build(BuildContext context) {
    final mapBlocLC = BlocProvider.of<MapBlocLC>(context);

    const CameraPosition initialCameraPositionLC = CameraPosition(
      target: LatLng(-36.61138113884416, -72.11756705684562),
      zoom: 18,
    );

    CameraTargetBounds cameraTargetBoundsLC = CameraTargetBounds(
      LatLngBounds(
        southwest: const LatLng(-36.61183724712687, -72.12075140139292),
        northeast: const LatLng(-36.609696380189696, -72.11426011574655),
      ),
    );

    final size = MediaQuery.of(context).size;

    final allMarkersLC = {
      ...widget.markersLC,
      ...mapBlocLC.state.medicalMarkersLC.values,
    };

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (_) => mapBlocLC.add(OnStopFollowingUserEventLC()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPositionLC,
          cameraTargetBounds: cameraTargetBoundsLC,
          compassEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          polylines: widget.polylinesLC,
          zoomGesturesEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference(17.0, 20.0),
          markers: mapBlocLC.state.showMedicalMarkersLC
              ? Set<Marker>.from(allMarkersLC)
              : Set<Marker>.from(widget.markersLC),
          rotateGesturesEnabled: true,
          onMapCreated: (controller) =>
              mapBlocLC.add(OnMapInitializedEventLC(controller)),
          onCameraMove: (position) => mapBlocLC.mapCenterLC = position.target,
        ),
      ),
    );
  }
}
