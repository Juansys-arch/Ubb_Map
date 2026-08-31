import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ubb/providers/providers.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/ui/input_decorations.dart';
import 'package:ubb/ui/ui.dart';
import 'package:ubb/widgets/dialog_widget.dart';

import '../services/services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isKeyboardVisible
                      ? size.height * 0.15
                      : size.height * 0.25,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        'assets/icons/signin_icon.svg',
                        height: isKeyboardVisible
                            ? size.height * 0.07
                            : size.height * 0.15,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Registrar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 9, 27, 43),
                            fontSize: 35,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.03),
                      // SizedBox(height: 30),
                      ChangeNotifierProvider(
                        create: (_) => RegisterFormProvider(),
                        child: _RegisterForm(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: TextButton(
                onPressed: () => context.replace('/login'),
                style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(
                        AppColors.primary.withOpacity(0.1)),
                    shape: WidgetStateProperty.all(const StadiumBorder())),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: 'Inicia sesión',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(
        context); //se obtiene el acceso a todo el LoginFormProvider

    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: FadeIn(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre',
                labelText: 'Nombre',
              ),
              onChanged: (value) => registerForm.nombre = value,
              validator: (value) {
                // Verificar si el campo está vacío
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto';
                }

                // Verificar si la longitud está entre 2 y 30 caracteres
                if (value.length < 2 || value.length > 30) {
                  return 'El nombre debe contener entre 2 a 30 caracteres';
                }

                // Verificar si hay caracteres no válidos
                RegExp nombreUsuario = RegExp(r'^[a-zA-Zá-úÁ-ÚüÜñÑ\s]{2,30}$');
                if (!nombreUsuario.hasMatch(value)) {
                  return 'Has ingresado un carácter no válido';
                }

                // Si pasa todas las validaciones, retorna null
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Apellido',
                labelText: 'Apellido',
              ),
              onChanged: (value) => registerForm.apellido = value,
              validator: (value) {
                // Verificar si el campo está vacío
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto';
                }

                // Verificar si la longitud está entre 2 y 30 caracteres
                if (value.length < 2 || value.length > 30) {
                  return 'El apellido debe contener entre 2 a 30 caracteres';
                }

                // Verificar si hay caracteres no válidos
                RegExp apellidoUsuario =
                    RegExp(r'^[a-zA-Zá-úÁ-ÚüÜñÑ\s]{2,30}$');
                if (!apellidoUsuario.hasMatch(value)) {
                  return 'Has ingresado un carácter no válido';
                }

                // Si pasa todas las validaciones, retorna null
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'nombre.apellido0000@alumnos.ubiobio.cl',
                labelText: 'Correo electrónico',
              ),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                // Verificar si el campo está vacío
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto';
                }

                // Verificar si la longitud está entre 14 y 100 caracteres
                if (value.length < 14 || value.length > 100) {
                  return 'El correo debe tener entre 14 y 100 caracteres';
                }

                // Verificar si el correo tiene el formato correcto
                RegExp emailUsuario =
                    RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
                if (!emailUsuario.hasMatch(value)) {
                  return 'El correo no es válido';
                }

                // Si pasa todas las validaciones, retorna null
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: !showPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      showPassword
                          ? 'assets/icons/visibility.svg'
                          : 'assets/icons/visibility_off.svg',
                    ),
                  ),
                ),
              ),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                // Verificar si el campo está vacío
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto.';
                }

                // Verificar la longitud de la contraseña
                if (value.length < 6) {
                  return 'La contraseña debe contener al menos 6 caracteres.';
                }

                // Verificar si la contraseña contiene al menos una letra mayúscula y una minúscula
                bool hasUppercase = false;
                bool hasLowercase = false;

                for (int i = 0; i < value.length; i++) {
                  if (RegExp(r'[a-zA-Z]').hasMatch(value[i])) {
                    if (value[i].toUpperCase() == value[i]) {
                      hasUppercase = true;
                    } else if (value[i].toLowerCase() == value[i]) {
                      hasLowercase = true;
                    }
                  }

                  if (hasUppercase && hasLowercase) {
                    return null;
                  }
                }

                // Si no cumple con las condiciones anteriores, mostrar mensaje de error
                return 'Se requiere una letra mayúscula y una minúscula.';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: AppColors.primary,
                onPressed: registerForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!registerForm.isValidForm()) return;

                        registerForm.isLoading = true;

                        final String? errorMessage =
                            await authService.createUser(
                                registerForm.nombre,
                                registerForm.apellido,
                                registerForm.email,
                                registerForm.password);
                        if (errorMessage == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => DialogWidget(
                                    iconPath: 'email_icon',
                                    text:
                                        'Se ha enviado un correo para activar tu cuenta. Por favor, verifica tu bandeja de entrada',
                                    onPressed: () => context.replace('/login'),
                                  ));
                          ;
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const DialogWidget(
                                    iconPath: 'warning_icon',
                                    text:
                                        'Ya existe una cuenta registrada con este correo electrónico.',
                                  ));
                          registerForm.isLoading = false;
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        registerForm.isLoading ? 'Espere...' : 'Registrar',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
