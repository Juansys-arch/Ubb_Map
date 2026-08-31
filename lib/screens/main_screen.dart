import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:ubb/screens/screens.dart';
import 'package:ubb/themes/colors_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const MapsOptionsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: AppColors.primary,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        iconSize: 30,
        activeColor: AppColors.white,
        inactiveColor: Colors.white70,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Inicio',
          ),
          BarItem(
            icon: Icons.map,
            title: 'Mapas',
          ),
          BarItem(
            icon: Icons.person_outline_outlined,
            title: 'Perfil',
          ),
        ],
      ),
    );
  }
}
