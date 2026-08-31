import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ubb/themes/colors_theme.dart';


class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.grey.shade100,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _BlueBox(),
          _HeaderIcon(size: size),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.07,
            left: size.width * 0.4,
            right: size.width * 0.4,
          ),
          child: FadeInDown(
            child: const FaIcon(
              FontAwesomeIcons.userGraduate,
              color: AppColors.white,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class _BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: const BoxDecoration(color: Color(0xFF1A3253)),
    );
  }
}
