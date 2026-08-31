import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/helpers/helpers.dart';
import 'package:ubb/themes/colors_theme.dart';

class ManualMarkerLC extends StatelessWidget {
  const ManualMarkerLC({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBlocLC, SearchStateLC>(
      builder: (context, state) {
        return state.displayManualMarkerLC
            ? const _ManualMarkerBodyLC()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBodyLC extends StatelessWidget {
  const _ManualMarkerBodyLC();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBlocLC = BlocProvider.of<SearchBlocLC>(context);
    final locationBlocLC = BlocProvider.of<LocationBloc>(context);
    final mapBlocLC = BlocProvider.of<MapBlocLC>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(top: 110, left: 20, child: _BtnBack()),

          Center(
            child: Transform.translate(
                offset: const Offset(0, -22),
                child: BounceInDown(
                  from: 100,
                  child: const Icon(Icons.location_on_rounded,
                      size: 60, color: Color.fromARGB(255, 9, 27, 43)),
                )),
          ),

          // Boton de confirmardestino
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width - 120,
                color: AppColors.primary,
                elevation: 0,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () async {
                  final start = locationBlocLC.state.lastKnowLocation;
                  if (start == null) return;

                  final end = mapBlocLC.mapCenterLC;
                  if (end == null) return;

                  showLoadingMessage(context);

                  final destination =
                      await searchBlocLC.getCoorsStartToEnd(start, end);
                  await mapBlocLC.drawRoutePolyline(destination);

                  searchBlocLC.add(OnDeactivateManualMarkerEventLC());

                  context.pop();
                },
                child: const Text('Confimar destino',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack();

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: AppColors.primary,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
          onPressed: () {
            BlocProvider.of<SearchBlocLC>(context)
                .add(OnDeactivateManualMarkerEventLC());
          },
        ),
      ),
    );
  }
}
