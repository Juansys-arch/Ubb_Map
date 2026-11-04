import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    const ScheduleScreen(),
    const MapsOptionsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          screens[0],
          screens[1],
          screens[2],
          CampusInfoScreen(
            onNavigateToMap: (event) => context.push(
              '/map_screen',
              extra: {
                'latitude': event.latitude,
                'longitude': event.longitude,
                'name': event.locationName,
              },
            ),
          ),
          screens[3],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.primary,
        indicatorColor: AppColors.white.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: AppColors.white, fontSize: 11),
        ),
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.home, color: AppColors.white),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.calendar_month, color: AppColors.white),
            label: 'Horario',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.map, color: AppColors.white),
            label: 'Mapas',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.event, color: AppColors.white),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white70),
            selectedIcon: Icon(Icons.person, color: AppColors.white),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
