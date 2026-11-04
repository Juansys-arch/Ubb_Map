import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubb/blocs/weather/weather_cubit.dart';
import 'package:ubb/blocs/weather/weather_state.dart';
import 'package:ubb/helpers/status_enum.dart';
import 'package:ubb/services/weather_service.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/widgets/forecast_weather_widget.dart';
import 'package:ubb/widgets/home_content.dart';
import 'package:ubb/widgets/home_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherCubit(WeatherService())..fetchWeatherDataAndForecast(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const WeatherSkeleton();
            } else if (state.status == Status.success) {
              return Column(
                children: [
                  PageTitle(weatherDataList: state.weatherDataList!),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Hoy',
                                  style: GoogleFonts.roboto(
                                    color: AppColors.primary,
                                    fontSize: 24,
                                  ),
                                ),
                                ChoiceChip(
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide.none,
                                  ),
                                  selectedColor: AppColors.primary,
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  label: Text(
                                    'Concepción',
                                    style: TextStyle(
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  selected: selectedIndex == 0,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  pressElevation: 0,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide.none,
                                  ),
                                  selectedColor: AppColors.primary,
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  label: Text(
                                    'Chillán',
                                    style: TextStyle(
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  selected: selectedIndex == 1,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  pressElevation: 0,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedIndex = 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 16,
                              right: 16,
                            ),
                            child: ForecastWeatherWidget(index: selectedIndex),
                          ),
                          const SizedBox(height: 16),
                          const _BuildingQuickGuide(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state.status == Status.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Error al cargar los datos'),
              );
            } else {
              return const Center(
                child: Text('Presiona el botón para cargar el clima'),
              );
            }
          },
        ),
      ),
    );
  }
}

class _BuildingQuickGuide extends StatelessWidget {
  const _BuildingQuickGuide();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guía de Edificios y FAQ',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rectoría, DDE, Finanzas y cómo llegar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '¿Tienes dudas sobre dónde realizar tus trámites o cómo llegar a los edificios administrativos?',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.explore_outlined, size: 18),
                label: const Text(
                  'Consultar Dudas y Ubicaciones',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => context.push('/building_info'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
