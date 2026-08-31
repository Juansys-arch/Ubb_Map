import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubb/blocs/weather/weather_cubit.dart';
import 'package:ubb/blocs/weather/weather_state.dart';
import 'package:ubb/helpers/status_enum.dart';
import 'package:ubb/themes/colors_theme.dart';

class ForecastWeatherWidget extends StatelessWidget {
  final int index;

  const ForecastWeatherWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == Status.error) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Error desconocido',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          );
        } else if (state.forecastList != null &&
            state.forecastList!.isNotEmpty) {
          final selectedForecastList = state.forecastList![index];

          return SizedBox(
            height: size.height * 0.12,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedForecastList.length,
              itemBuilder: (context, forecastIndex) {
                final forecast = selectedForecastList[forecastIndex];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: size.width * 0.18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1.5,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${forecast.temperature.toStringAsFixed(1)}°C',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Image.asset(
                          'assets/weather_img/${forecast.icon}.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          '${forecast.dateTime.hour}:00',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('No hay pronóstico disponible.'),
          );
        }
      },
    );
  }
}
