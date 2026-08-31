import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/delegates/delegates.dart';
import 'package:ubb/helpers/helpers.dart';
import 'package:ubb/models/models.dart';
import 'package:ubb/themes/colors_theme.dart';

import '../widgets.dart';

class SearchBarLC extends StatelessWidget {
  const SearchBarLC({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBlocLC, SearchStateLC>(
      builder: (context, state) {
        return state.displayManualMarkerLC
            ? const SizedBox()
            : FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: const _SearchBarBodyLC(),
              );
      },
    );
  }
}

class _SearchBarBodyLC extends StatelessWidget {
  const _SearchBarBodyLC();

  void onSearchResultsLC(BuildContext context, SearchResult result) async {
    final searchBlocLC = BlocProvider.of<SearchBlocLC>(context);
    final locationBlocLC = BlocProvider.of<LocationBloc>(context);
    final mapBlocLC = BlocProvider.of<MapBlocLC>(context);

    if (result.manual == true) {
      searchBlocLC.add(OnActivateManualMarkerEventLC());
      return;
    }

    if (result.position != null) {
      showLoadingMessage(context);

      final destination = await searchBlocLC.getCoorsStartToEnd(
        locationBlocLC.state.lastKnowLocation!,
        result.position!,
      );
      await mapBlocLC.drawRoutePolyline(destination);

      final newCameraPositionLC = CameraPosition(
        target: destination.points.last,
      );
      final newLocationLC = newCameraPositionLC.target;
      mapBlocLC.moveCamera(newLocationLC);

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            const BtnBack(),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await showSearch(
                    context: context,
                    delegate: SearchDestinationDelegateLC(),
                  );
                  if (result == null) return;
                  // ignore: use_build_context_synchronously
                  onSearchResultsLC(context, result);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '¿Dónde quieres ir?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
