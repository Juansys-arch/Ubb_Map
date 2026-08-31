import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/cross_ubication.svg',
          width: 20,
          height: 20,
        ),
        onPressed: () {
          final userLocation = locationBloc.state.lastKnowLocation;
          if (userLocation == null) return;
          mapBloc.moveCamera(userLocation);
        },
      ),
    );
  }
}
