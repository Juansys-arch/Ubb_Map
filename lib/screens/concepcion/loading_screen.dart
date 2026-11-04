import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  /// Código corto para mostrar en el banner (ej: "S101")
  final String? roomCode;

  /// Código completo con sección para buscar en Firebase (ej: "S101 FG")
  final String? roomSearchCode;

  /// Nombre del edificio como fallback de búsqueda (ej: "Edificio S")
  final String? building;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationName;

  const LoadingScreen({
    super.key,
    this.roomCode,
    this.roomSearchCode,
    this.building,
    this.destinationLatitude,
    this.destinationLongitude,
    this.destinationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted
            ? MapScreen(
                roomCode: roomCode,
                roomSearchCode: roomSearchCode,
                building: building,
                destinationLatitude: destinationLatitude,
                destinationLongitude: destinationLongitude,
                destinationName: destinationName,
              )
            : const GpsAccessScreen();
      },
    ));
  }
}
