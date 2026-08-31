import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';

class BtnCurrentLocationLC extends StatelessWidget {
  const BtnCurrentLocationLC({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBlocLC = BlocProvider.of<LocationBloc>(context);
    final mapBlocLC = BlocProvider.of<MapBlocLC>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: AppColors.primary,
        maxRadius: 25,
        child: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/cross_ubication.svg',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            final userLocation = locationBlocLC.state.lastKnowLocation;
            if (userLocation == null) return;
            mapBlocLC.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}
