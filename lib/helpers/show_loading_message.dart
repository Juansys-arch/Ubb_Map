import 'dart:ui'; // Necesario para BackdropFilter
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubb/themes/colors_theme.dart';

void showLoadingMessage(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => BounceInDown(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Calculando ruta',
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
                SizedBox(height: 15),
                Text(
                  'Un momento por favor ...',
                  style: TextStyle(color: AppColors.white),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return;
}
