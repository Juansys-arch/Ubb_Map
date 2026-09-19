import 'dart:async';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/views/views.dart';
import 'package:ubb/widgets/widgets.dart';
import 'package:ubb/models/models.dart';

class MapScreen extends StatefulWidget {
  /// Código corto para mostrar en el banner (ej: "S101")
  final String? roomCode;
  /// Código completo con sección para buscar en Firebase (ej: "S101 FG")
  /// Si es null, se usa roomCode como query de búsqueda.
  final String? roomSearchCode;
  /// Nombre del edificio como fallback de búsqueda (ej: "Edificio S")
  final String? building;

  const MapScreen({
    super.key,
    this.roomCode,
    this.roomSearchCode,
    this.building,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  StreamSubscription<LocationState>? _locationSub;
  bool _routeDrawn = false;
  bool _isSearchingRoute = false;

  /// Query principal para buscar en Firebase.
  /// Usa el código con sección si está disponible, si no el código corto.
  String? get _searchQuery => widget.roomSearchCode ?? widget.roomCode;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();

    if (_searchQuery != null || widget.building != null) {
      _waitForLocationAndDraw();
    }
  }

  void _waitForLocationAndDraw() {
    if (locationBloc.state.lastKnowLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _drawRouteToRoom());
      return;
    }

    _locationSub = locationBloc.stream.listen((state) {
      if (state.lastKnowLocation != null && !_routeDrawn && !_isSearchingRoute) {
        _locationSub?.cancel();
        _locationSub = null;
        WidgetsBinding.instance.addPostFrameCallback((_) => _drawRouteToRoom());
      }
    });
  }

  /// Busca el aula en Firebase y traza la ruta.
  ///
  /// Estrategia de búsqueda:
  /// 1. Busca con el código completo (ej: "S101 FG") → el regex extrae "FG"
  ///    y busca en placeName. Firebase tiene entradas como "S101II", "FG", etc.
  /// 2. Fallback: busca por nombre del edificio (ej: "Edificio S")
  Future<void> _drawRouteToRoom() async {
    if (_routeDrawn || _isSearchingRoute || !mounted) return;

    final currentLocation = locationBloc.state.lastKnowLocation;
    if (currentLocation == null) return;

    setState(() => _isSearchingRoute = true);

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    try {
      // 1️⃣ Buscar con el código completo (ej: "S101 FG")
      var places = <Feature>[];
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        places = await searchBloc.getPlacesByQuery(currentLocation, _searchQuery!);
      }

      // 2️⃣ Fallback: buscar por nombre del edificio (ej: "Edificio S")
      if (places.isEmpty && widget.building != null && widget.building!.isNotEmpty) {
        places = await searchBloc.getPlacesByQuery(currentLocation, widget.building!);
      }

      if (!mounted) return;

      if (places.isEmpty) {
        setState(() => _isSearchingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se encontró "${widget.roomCode ?? _searchQuery}".\nBusca manualmente con el buscador.',
            ),
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      // 3️⃣ Obtener ruta hacia el primer resultado
      final destination = await searchBloc.getCoorsStartToEnd(
        currentLocation,
        LatLng(places.first.center[1], places.first.center[0]),
      );

      if (!mounted) return;

      _routeDrawn = true;
      setState(() => _isSearchingRoute = false);

      await mapBloc.drawRoutePolyline(destination);

      if (mounted) {
        mapBloc.moveCamera(destination.points.last);
      }
    } catch (e) {
      _routeDrawn = false;
      if (mounted) {
        setState(() => _isSearchingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al calcular la ruta. Intenta de nuevo.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowLocation == null) {
            return Padding(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LinearProgressIndicator(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      minHeight: 10,
                      color: AppColors.primary,
                    ),
                    if (widget.roomCode != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Obteniendo ubicación para navegar a ${widget.roomCode}...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
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

                  // Spinner mientras se calcula la ruta
                  if (_isSearchingRoute)
                    Positioned(
                      top: 70,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Buscando ruta a ${widget.roomCode ?? _searchQuery}...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Banner de destino cuando la ruta está trazada
                  if (widget.roomCode != null && _routeDrawn)
                    _RoomDestinationBanner(roomCode: widget.roomCode!),
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

class _RoomDestinationBanner extends StatelessWidget {
  final String roomCode;
  const _RoomDestinationBanner({required this.roomCode});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.school_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Navegando a: $roomCode',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
