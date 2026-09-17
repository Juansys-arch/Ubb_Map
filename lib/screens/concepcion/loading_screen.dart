import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  final String? destinationRoom;
  final String? destinationBuilding;
  final String? destinationLat;
  final String? destinationLng;

  const LoadingScreen({
    super.key,
    this.destinationRoom,
    this.destinationBuilding,
    this.destinationLat,
    this.destinationLng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted
            ? MapScreen(
                destinationRoom: destinationRoom,
                destinationBuilding: destinationBuilding,
                destinationLat: destinationLat,
                destinationLng: destinationLng,
              )
            : const GpsAccessScreen();
      },
    ));
  }
}
