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
      builder: (context, state) => const LoadingScreen(),
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
