import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/screens/building_info_screen.dart';
import 'package:ubb/screens/schedule_screen.dart';
import 'package:ubb/services/services.dart';

import 'test_setup.dart';

GoRouter createIntegrationRouter({
  required ScheduleService scheduleService,
}) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const IntegrationLoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, __) => Scaffold(
          appBar: AppBar(title: const Text('Demostración UBBMap')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Sesión MongoDB activa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.push('/schedule'),
                child: const Text('Ver horario'),
              ),
              FilledButton(
                onPressed: () => context.push('/building_info'),
                child: const Text('Guía de edificios'),
              ),
              FilledButton(
                onPressed: () => context.push('/map_search'),
                child: const Text('Buscar destino en el mapa'),
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: '/schedule',
        builder: (_, __) => ScheduleScreen(scheduleService: scheduleService),
      ),
      GoRoute(
        path: '/map_screen',
        builder: (context, state) => IntegrationMapScreen(
          extra: state.extra as Map<String, dynamic>? ?? {},
        ),
      ),
      GoRoute(
        path: '/map_screen_fm',
        builder: (context, state) => IntegrationMapScreen(
          extra: state.extra as Map<String, dynamic>? ?? {},
        ),
      ),
      GoRoute(
        path: '/map_screen_lc',
        builder: (context, state) => IntegrationMapScreen(
          extra: state.extra as Map<String, dynamic>? ?? {},
        ),
      ),
      GoRoute(
        path: '/building_info',
        builder: (_, __) => const BuildingInfoScreen(),
      ),
      GoRoute(
        path: '/map_search',
        builder: (_, __) => const IntegrationDestinationSearchScreen(),
      ),
    ],
  );
}

class IntegrationDestinationSearchScreen extends StatefulWidget {
  const IntegrationDestinationSearchScreen({super.key});

  @override
  State<IntegrationDestinationSearchScreen> createState() =>
      _IntegrationDestinationSearchScreenState();
}

class _IntegrationDestinationSearchScreenState
    extends State<IntegrationDestinationSearchScreen> {
  final queryController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  void _selectDestination() {
    context.push(
      '/map_screen',
      extra: const {
        'targetTitle': 'Edificio de Finanzas',
        'targetLocation': LatLng(-36.82195, -73.01285),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar destino'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isSearching)
              InkWell(
                onTap: () => setState(() => isSearching = true),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Text(
                    '¿Dónde quieres ir?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else ...[
              TextField(
                controller: queryController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Buscar...',
                  hintText: 'Ejemplo: Finanzas',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              if (queryController.text.trim().isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: const Text('Edificio de Finanzas'),
                  subtitle: const Text('Campus Concepción'),
                  onTap: _selectDestination,
                ),
            ],
            if (!isSearching)
              const Expanded(
                child: Center(
                  child: Text('Busca una sala o edificio del campus'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class IntegrationLoginScreen extends StatefulWidget {
  const IntegrationLoginScreen({super.key});

  @override
  State<IntegrationLoginScreen> createState() => _IntegrationLoginScreenState();
}

class _IntegrationLoginScreenState extends State<IntegrationLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await loginMongoTestUser();
      if (mounted) context.replace('/home');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UBBMap')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          const Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'nombre.apellido0000@alumnos.ubiobio.cl',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              hintText: '*****',
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: isLoading ? null : _login,
            child: Text(isLoading ? 'Espere...' : 'Ingresar'),
          ),
        ],
      ),
    );
  }
}

class IntegrationMapScreen extends StatelessWidget {
  const IntegrationMapScreen({required this.extra, super.key});

  final Map<String, dynamic> extra;

  @override
  Widget build(BuildContext context) {
    final target = extra['targetTitle'] ?? '';
    final room = extra['room'] ?? '';
    final building = extra['building'] ?? '';
    final destination = target.toString().isNotEmpty
        ? target.toString()
        : [room, building]
            .where((value) => value.toString().trim().isNotEmpty)
            .join(' · ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del campus'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Buscar sala o edificio'),
            const SizedBox(height: 8),
            Text(
              destination.isEmpty ? 'Destino seleccionado' : destination,
              style: const TextStyle(fontSize: 20),
            ),
            const Expanded(
              child: Center(
                child: Icon(Icons.map, size: 96),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntegrationTestApp extends StatelessWidget {
  const IntegrationTestApp({
    required this.router,
    super.key,
  });

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
