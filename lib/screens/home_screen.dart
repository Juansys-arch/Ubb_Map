import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
