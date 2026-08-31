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
