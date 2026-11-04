import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  /// Código corto para mostrar en el banner (ej: "S101")
  final String? roomCode;

  /// Código completo con sección para buscar en Firebase (ej: "S101 FG")
  final String? roomSearchCode;

  /// Nombre del edificio como fallback de búsqueda (ej: "Edificio S")
  final String? building;

  /// Coordenadas de destino directo (ej: para eventos, Rectoría, DDE, Finanzas)
  final LatLng? targetLocation;

  /// Título de destino directo
  final String? targetTitle;

  const LoadingScreen({
    super.key,
    this.roomCode,
    this.roomSearchCode,
    this.building,
    this.targetLocation,
    this.targetTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted
              ? MapScreen(
                  roomCode: roomCode,
                  roomSearchCode: roomSearchCode,
                  building: building,
                  targetLocation: targetLocation,
                  targetTitle: targetTitle,
                )
              : const GpsAccessScreen();
        },
      ),
    );
  }
}