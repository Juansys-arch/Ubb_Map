import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:google_fonts/google_fonts.dart';

final List<Map<String, String>> campusData = [
  {'name': 'Concepción', 'info': 'Concepción', 'route': '/map_screen'},
  {'name': 'Fernando May', 'info': 'Chillán', 'route': '/map_screen_fm'},
  {'name': 'La Castilla', 'info': 'Chillán', 'route': '/map_screen_lc'},
];

class MapsOptions extends StatelessWidget {
  const MapsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
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
                'Mapas',
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 30,
            right: 30,
          ),
          child: Text(
            'Selecciona tu campus para acceder al mapa correspondiente y explorar sus ubicaciones.',
            style: GoogleFonts.roboto(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Banner Guía de Edificios y FAQ
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: GestureDetector(
            onTap: () => context.push('/building_info'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF2C4A75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guía de Edificios y FAQ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Dudas sobre Rectoría, DDE, Finanzas...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView.builder(
              itemCount: campusData.length,
              itemBuilder: (BuildContext context, int index) {
                final campus = campusData[index];
                return GestureDetector(
                  onTap: () => context.push(campus['route']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🔹 Thumbnail (lado izquierdo)
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade300,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/map_icon.svg',
                              width: 22,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 🔹 Texto (expandido)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campus['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    campus['info'] ?? 'Main Hub',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 🔹 Flecha derecha
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
                // return Card(

                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   shadowColor: AppColors.textPrimary,
                //   color: const Color(0xFFFFFFFF),
                //   elevation: 1,
                //   margin: const EdgeInsets.symmetric(vertical: 15),
                //   child: ListTile(
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 30,
                //       vertical: 5,
                //     ),
                //     leading: SvgPicture.asset(
                //       'assets/icons/map_icon.svg',
                //       width: 15,
                //       color: AppColors.primary,
                //     ),
                //     title: Text(
                //       campus['name']!,
                //       style: const TextStyle(
                //         color: AppColors.primary,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //     trailing: SvgPicture.asset(
                //       'assets/icons/arrow_right_icon.svg',
                //       width: 8,
                //       color: AppColors.primary,
                //     ),
                //     onTap: () {
                //       context.push(campus['route']!);
                //     },
                //   ),
                // );
              },
            ),
          ),
        ),
      ],
    );
  }
}
