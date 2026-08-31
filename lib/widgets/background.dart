import 'dart:math';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});
  final boxDecoration = const BoxDecoration(
    gradient: LinearGradient(
      // begin: Alignment.topCenter,
      // end: Alignment.bottomCenter,
      stops: [0, 1],
      colors: [
        Color.fromARGB(255, 9, 27, 43),
        Color.fromRGBO(14, 150, 171, 1),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: boxDecoration),
        Positioned(
          top: -100,
          left: -30,
          child: _BlueLightBox(),
        ),
      ],
    );
  }
}

class _BlueLightBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: 1,
        height: 1,
        decoration: BoxDecoration(
            color: const Color(0xff00A2C5),
            borderRadius: BorderRadius.circular(80),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(14, 150, 171, 1),
              Color.fromRGBO(35, 224, 255, 1),
            ])),
      ),
    );
  }
}
