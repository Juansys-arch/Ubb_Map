import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/views/views.dart';
import 'package:ubb/widgets/widgets.dart';

class MapScreenLC extends StatefulWidget {
  const MapScreenLC({super.key});

  @override
  State<MapScreenLC> createState() => _MapScreenStateLC();
}

class _MapScreenStateLC extends State<MapScreenLC> {
  late LocationBloc locationBlocLC;

  @override
  void initState() {
    super.initState();
    locationBlocLC = BlocProvider.of<LocationBloc>(context);
    locationBlocLC.startFollowingUser();
  }

  @override
  void dispose() {
    locationBlocLC.stopFollowingUser();
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

          return BlocBuilder<MapBlocLC, MapStateLC>(
            builder: (context, mapStateLC) {
              Map<String, Polyline> polylinesLC = Map.from(mapStateLC.polylinesLC);
              if (!mapStateLC.showMyRouteLC) {
                polylinesLC.removeWhere((key, value) => key == 'myRoute');
              }

              return Stack(
                children: [
                  MapViewLC(
                    polylinesLC: polylinesLC.values.toSet(),
                    markersLC: mapStateLC.markersLC.values.toSet(),
                  ),
                  const SearchBarLC(),
                  const ManualMarkerLC(),
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
              BtnToggleMarkerLC(),
              BtnFollowUserLC(),
              BtnCurrentLocationLC(),
            ],
          );
        },
      ),
    );
  }
}
