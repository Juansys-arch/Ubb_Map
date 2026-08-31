import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ubb/themes/colors_theme.dart';

class BtnBack extends StatelessWidget {
  const BtnBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back_arrow.svg',
          width: 20,
          height: 20,
        ),
        onPressed: () {
          context.pop();
        },
      ),
    );
  }
}
