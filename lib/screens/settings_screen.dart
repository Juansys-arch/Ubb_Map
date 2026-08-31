import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubb/themes/colors_theme.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            height: size.height * 0.15,
            width: size.width,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Text(
                  'Perfil',
                  style: GoogleFonts.roboto(
                    color: AppColors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.1,
              ),
              child: Text(
                'Mis datos',
                style: GoogleFonts.roboto(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SettingsTitle(),
        ],
      ),
    );
  }
}
