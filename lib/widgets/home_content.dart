import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubb/themes/colors_theme.dart';
import '../models/weather_data.dart';
import 'weather_card.dart';

class PageTitle extends StatelessWidget {
  final List<WeatherData> weatherDataList;
  final PageController _pageController = PageController(initialPage: 0);

  PageTitle({super.key, required this.weatherDataList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              Text(
                'Inicio',
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: weatherDataList.length,
                  onPageChanged: (index) => _pageController.jumpToPage(index),
                  itemBuilder: (context, index) {
                    final weatherData = weatherDataList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                      ),
                      child: SizedBox(
                        width: size.width * 0.8,
                        child: WeatherCardWidget(weatherData: weatherData),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(weatherDataList.length, (index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double selectedness =
                        (_pageController.page ?? 0.0) == index ? 1.0 : 0.0;
                    return _buildStepCircle(selectedness);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(double selectedness) {
    final double size = 8.0 + (12.0 * selectedness);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: selectedness == 1.0 ? AppColors.white : Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
