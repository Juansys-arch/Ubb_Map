import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../screens/screens.dart';

final GoRouter router = GoRouter(
  initialLocation: '/checking',
  routes: [
    GoRoute(
      path: '/checking',
      builder: (context, state) => const CheckAuthScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/map_screen',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        // Soporta targetLocation directo o coordenadas desglosadas enviadas desde eventos
        LatLng? resolvedLocation = extra?['targetLocation'] as LatLng?;
        if (resolvedLocation == null &&
            extra?['latitude'] != null &&
            extra?['longitude'] != null) {
          resolvedLocation = LatLng(
            (extra!['latitude'] as num).toDouble(),
            (extra['longitude'] as num).toDouble(),
          );
        }

        return LoadingScreen(
          roomCode: extra?['room'] as String?,
          roomSearchCode: extra?['code'] as String?,
          building: extra?['building'] as String?,
          targetLocation: resolvedLocation,
          targetTitle: (extra?['targetTitle'] ?? extra?['name']) as String?,
        );
      },
    ),
    GoRoute(
      path: '/building_info',
      builder: (context, state) => const BuildingInfoScreen(),
    ),
    GoRoute(
      path: '/map_screen_fm',
      builder: (context, state) => const LoadingScreenFM(),
    ),
    GoRoute(
      path: '/map_screen_lc',
      builder: (context, state) => const LoadingScreenLC(),
    ),
    GoRoute(
      path: '/maps_options',
      builder: (context, state) => const MapsOptionsScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const PasswordResetScreen(),
    ),
  ],
);