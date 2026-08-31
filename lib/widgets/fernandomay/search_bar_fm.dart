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

class SearchBarFM extends StatelessWidget {
  const SearchBarFM({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBlocFM, SearchStateFM>(
      builder: (context, state) {
        return state.displayManualMarkerFM
            ? const SizedBox()
            : FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: const _SearchBarBodyFM(),
              );
      },
    );
  }
}

class _SearchBarBodyFM extends StatelessWidget {
  const _SearchBarBodyFM();

  void onSearchResultsFM(BuildContext context, SearchResult result) async {
    final searchBlocFM = BlocProvider.of<SearchBlocFM>(context);
    final locationBlocFM = BlocProvider.of<LocationBloc>(context);
    final mapBlocFM = BlocProvider.of<MapBlocFM>(context);

    if (result.manual == true) {
      searchBlocFM.add(OnActivateManualMarkerEventFM());
      return;
    }

    if (result.position != null) {
      showLoadingMessage(context);

      final destination = await searchBlocFM.getCoorsStartToEnd(
        locationBlocFM.state.lastKnowLocation!,
        result.position!,
      );
      await mapBlocFM.drawRoutePolyline(destination);

      final newCameraPositionFM = CameraPosition(
        target: destination.points.last,
      );
      final newLocationFM = newCameraPositionFM.target;
      mapBlocFM.moveCamera(newLocationFM);

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
                    delegate: SearchDestinationDelegateFM(),
                  );
                  if (result == null) return;
                  // ignore: use_build_context_synchronously
                  onSearchResultsFM(context, result);
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
