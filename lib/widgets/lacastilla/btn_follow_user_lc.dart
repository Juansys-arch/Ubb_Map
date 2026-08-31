import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';

class BtnFollowUserLC extends StatelessWidget {
  const BtnFollowUserLC({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBlocLC = BlocProvider.of<MapBlocLC>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: AppColors.primary,
        maxRadius: 25,
        child: BlocBuilder<MapBlocLC, MapStateLC>(
          builder: (context, state) {
            return IconButton(
                 icon: SvgPicture.asset(
                color: AppColors.white,
                state.isFollowingUserLC
                    ? 'assets/icons/directions_run.svg'
                    : 'assets/icons/hail_icon.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                mapBlocLC.add(OnStartFollowingUserEventLC());
              },
            );
          },
        ),
      ),
    );
  }
}
