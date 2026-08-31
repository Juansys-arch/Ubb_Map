import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/ui/input_decorations.dart';
import '../services/services.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.03),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: authService.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text(
                          'Error al obtener los datos del usuario');
                    } else {
                      final userData = snapshot.data ?? {};
                      final displayName = userData['displayName'] ?? '';
                      final email = userData['email'] ?? '';
                      final createdAt = userData['createdAt'] ?? '';
                      final formattedDate = createdAt.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(createdAt),
                              ),
                            )
                          : '';

                      return Column(
                        children: [
                          TextFormField(
                            initialValue: displayName,
                            readOnly: true,
                            decoration: InputDecorations.authInputDecoration(
                              hintText: 'Nombre usuario',
                              labelText: 'Nombre usuario',
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          TextFormField(
                            initialValue: email,
                            readOnly: true,
                            decoration: InputDecorations.authInputDecoration(
                              hintText:
                                  'nombre.apellido0000@alumnos.ubiobio.cl',
                              labelText: 'Correo electrónico',
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          TextFormField(
                            initialValue: formattedDate,
                            readOnly: true,
                            decoration: InputDecorations.authInputDecoration(
                              hintText: 'Fecha de registro',
                              labelText: 'Fecha de registro',
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            child: Center(
              child: MaterialButton(
                minWidth: size.width * 0.8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromARGB(255, 90, 2, 2),
                onPressed: () {
                  authService.logout();
                  context.replace('/login');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
