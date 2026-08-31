import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/themes/colors_theme.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return IconButton(
            icon: SvgPicture.asset(
              color: AppColors.white,
              state.isFollowingUser
                  ? 'assets/icons/directions_run.svg'
                  : 'assets/icons/hail_icon.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              mapBloc.add(OnStartFollowingUserEvent());
            },
          );
        },
      ),
    );
  }
}
