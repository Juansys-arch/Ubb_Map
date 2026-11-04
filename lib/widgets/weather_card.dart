import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubb/helpers/weather_translations.dart';
import 'package:ubb/themes/colors_theme.dart';
import '../models/weather_data.dart';

class WeatherCardWidget extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherCardWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weatherData.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${weatherData.temperature.toStringAsFixed(1)}°',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  height: 0.95,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  weatherTranslations[weatherData.mainWeather] ??
                      weatherData.mainWeather,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              _WeatherDetail(
                icon: 'assets/icons/wind_icon.svg',
                value: '${weatherData.windSpeed.toStringAsFixed(1)} km/h',
                label: 'Viento',
              ),
              const SizedBox(width: 18),
              _WeatherDetail(
                icon: 'assets/icons/raind_drop_icon.svg',
                value: '${weatherData.humidity}%',
                label: 'Humedad',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _WeatherDetail({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon, width: 13, height: 13),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
