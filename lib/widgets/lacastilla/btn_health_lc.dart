import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ubb/themes/colors_theme.dart';

import '../../blocs/bloc.dart';

class BtnToggleMarkerLC extends StatelessWidget {
  const BtnToggleMarkerLC({
    super.key,
  });

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
                'assets/icons/health_icon.svg',
                width: 20,
                height: 20,
              ),
              onPressed: () {
                mapBlocLC.add(ToggleMedicalMarkersVisibilityEventLC());
              },
            );
          },
        ),
      ),
    );
  }
}
