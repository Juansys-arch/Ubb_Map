import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/models/models.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/views/views.dart';
import 'package:ubb/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  final String? destinationRoom;
  final String? destinationBuilding;
  final String? destinationLat;
  final String? destinationLng;

  const MapScreen({
    super.key,
    this.destinationRoom,
    this.destinationBuilding,
    this.destinationLat,
    this.destinationLng,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  bool _routeTriggered = false;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
  }

  Future<void> _waitForUserLocation() async {
    if (locationBloc.state.lastKnowLocation != null) return;

    final hasLocation = await locationBloc.getCurrentPosition();
    if (hasLocation == null) {
      await Future.delayed(const Duration(seconds: 1));
      await _waitForUserLocation();
    }
  }

  Future<void> _goToScheduledLocation() async {
    if (widget.destinationRoom == null || widget.destinationRoom!.trim().isEmpty) {
      return;
    }

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if (locationBloc.state.lastKnowLocation == null) {
      await _waitForUserLocation();
    }

    final currentLocation = locationBloc.state.lastKnowLocation;
    if (currentLocation == null) {
      return;
    }

    LatLng destinationPoint = const LatLng(-36.8220178016745, -73.0129262889358);

    final directLat = double.tryParse(widget.destinationLat ?? '');
    final directLng = double.tryParse(widget.destinationLng ?? '');
    if (directLat != null && directLng != null) {
      destinationPoint = LatLng(directLat, directLng);
    } else {
      final queryParts = <String>[];
      if (widget.destinationBuilding != null && widget.destinationBuilding!.trim().isNotEmpty) {
        queryParts.add(widget.destinationBuilding!.trim());
      }
      queryParts.add(widget.destinationRoom!.trim());

      final query = queryParts.join(' ');
      if (query.trim().isNotEmpty) {
        await searchBloc.getPlacesByQuery(currentLocation, query);

        for (final place in searchBloc.state.places) {
          final roomText = widget.destinationRoom!.trim().toUpperCase();
          final buildingText = (widget.destinationBuilding ?? '').trim().toUpperCase();
          final placeText = place.text.toUpperCase();
          final placeNames = place.placeName.map((name) => name.toUpperCase()).toList();

          final roomMatches = placeText.contains(roomText) ||
              placeNames.any((name) => name.contains(roomText));
          final buildingMatches = buildingText.isEmpty ||
              placeText.contains(buildingText) ||
              placeNames.any((name) => name.contains(buildingText));

          if (roomMatches && buildingMatches) {
            destinationPoint = LatLng(place.center[1], place.center[0]);
            break;
          }
        }
      }
    }

    final destination = await searchBloc.getCoorsStartToEnd(currentLocation, destinationPoint);
    await mapBloc.drawRoutePolyline(destination);
    mapBloc.moveCamera(destination.points.last);
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowLocation == null) {
            return const Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  minHeight: 10,
                  color: AppColors.primary,
                ),
              ),
            );
          }

          if (widget.destinationRoom != null &&
              !_routeTriggered &&
              locationState.lastKnowLocation != null) {
            _routeTriggered = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) return;
              await _goToScheduledLocation();
            });
          }

          if (locationState.lastKnowLocation == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) return;
              await _waitForUserLocation();
            });
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              if (!mapState.showMyRoute) {
                polylines.removeWhere((key, value) => key == 'myRoute');
              }

              return Stack(
                children: [
                  MapView(
                    polylines: polylines.values.toSet(),
                    markers: mapState.markers.values.toSet(),
                  ),
                  const SearchBar(),
                  const ManualMarker(),
                ],
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowLocation == null) {
            return const SizedBox.shrink();
          }

          return const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BtnToggleMarker(),
              BtnFollowUser(),
              BtnCurrentLocation(),
            ],
          );
        },
      ),
    );
  }
}
