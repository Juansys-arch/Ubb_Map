import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherSkeleton extends StatelessWidget {
  const WeatherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          _buildHeaderSkeleton(width, height),
          SizedBox(height: height * 0.05),
          _buildHourlySkeleton(width, height),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton(double width, double height) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.1,
        horizontal: width * 0.05,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A5F),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white24,
        highlightColor: Colors.white38,
        child: Column(
          children: [
            _box(width * 0.3, height * 0.025),
            SizedBox(height: height * 0.015),
            _box(width * 0.45, height * 0.02),
            SizedBox(height: height * 0.03),
            _circle(width * 0.2),
            SizedBox(height: height * 0.02),
            _box(width * 0.25, height * 0.05),
            SizedBox(height: height * 0.01),
            _box(width * 0.35, height * 0.02),
            SizedBox(height: height * 0.02),
            Divider(color: Colors.white24),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _columnStat(width, height),
                _columnStat(width, height),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _columnStat(double width, double height) {
    return Column(
      children: [
        _circle(width * 0.06),
        SizedBox(height: height * 0.01),
        _box(width * 0.15, height * 0.015),
        SizedBox(height: height * 0.005),
        _box(width * 0.12, height * 0.015),
      ],
    );
  }

  Widget _buildHourlySkeleton(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width * 0.2, height * 0.025),
          SizedBox(height: height * 0.015),
          SizedBox(
            height: height * 0.14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(width: width * 0.02),
              itemBuilder: (_, __) => _hourCard(width, height),
            ),
          )
        ],
      ),
    );
  }

  Widget _hourCard(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width * 0.18,
        padding: EdgeInsets.all(width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _box(width * 0.1, height * 0.02),
            _circle(width * 0.08),
            _box(width * 0.1, height * 0.015),
          ],
        ),
      ),
    );
  }

  Widget _box(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
