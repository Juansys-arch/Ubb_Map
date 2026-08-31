import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/helpers/helpers.dart';
import 'package:ubb/themes/colors_theme.dart';

class ManualMarkerFM extends StatelessWidget {
  const ManualMarkerFM({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBlocFM, SearchStateFM>(
      builder: (context, state) {
        return state.displayManualMarkerFM
            ? const _ManualMarkerBodyFM()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBodyFM extends StatelessWidget {
  const _ManualMarkerBodyFM();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBlocFM = BlocProvider.of<SearchBlocFM>(context);
    final locationBlocFM = BlocProvider.of<LocationBloc>(context);
    final mapBlocFM = BlocProvider.of<MapBlocFM>(context);

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
                  final start = locationBlocFM.state.lastKnowLocation;
                  if (start == null) return;

                  final end = mapBlocFM.mapCenterFM;
                  if (end == null) return;

                  showLoadingMessage(context);

                  final destination =
                      await searchBlocFM.getCoorsStartToEnd(start, end);
                  await mapBlocFM.drawRoutePolyline(destination);

                  searchBlocFM.add(OnDeactivateManualMarkerEventFM());

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
            BlocProvider.of<SearchBlocFM>(context)
                .add(OnDeactivateManualMarkerEventFM());
          },
        ),
      ),
    );
  }
}
