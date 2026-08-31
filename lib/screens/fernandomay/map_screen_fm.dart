import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/views/views.dart';
import 'package:ubb/widgets/widgets.dart';

class MapScreenFM extends StatefulWidget {
  const MapScreenFM({super.key});

  @override
  State<MapScreenFM> createState() => _MapScreenStateFM();
}

class _MapScreenStateFM extends State<MapScreenFM> {
  late LocationBloc locationBlocFM;

  @override
  void initState() {
    super.initState();
    locationBlocFM = BlocProvider.of<LocationBloc>(context);
    locationBlocFM.startFollowingUser();
  }

  @override
  void dispose() {
    locationBlocFM.stopFollowingUser();
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

          return BlocBuilder<MapBlocFM, MapStateFM>(
            builder: (context, mapStateFM) {
              Map<String, Polyline> polylinesFM =
                  Map.from(mapStateFM.polylinesFM);
              if (!mapStateFM.showMyRouteFM) {
                polylinesFM.removeWhere((key, value) => key == 'myRoute');
              }

              return Stack(
                children: [
                  MapViewFM(
                    polylinesFM: polylinesFM.values.toSet(),
                    markersFM: mapStateFM.markersFM.values.toSet(),
                  ),
                  const SearchBarFM(),
                  const ManualMarkerFM(),
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
              BtnToggleMarkerFM(),
              BtnFollowUserFM(),
              BtnCurrentLocationFM(),
            ],
          );
        },
      ),
    );
  }
}
