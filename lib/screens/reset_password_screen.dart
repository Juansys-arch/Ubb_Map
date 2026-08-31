import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ubb/helpers/routes.dart';
import 'package:ubb/providers/login_form_provider.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/ui/input_decorations.dart';
import 'package:ubb/ui/ui.dart';
import 'package:ubb/widgets/dialog_widget.dart';

import '../services/services.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/login_icon.svg',
                      height: size.height * 0.15,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.03),
                      Text(
                        'Recuperar cuenta',
                        style: GoogleFonts.roboto(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(),
                        child: _ResetPasswordForm(),
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
                    children: const [
                      TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      TextSpan(
                        text: 'Inicia sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

class _ResetPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resetPass = Provider.of<LoginFormProvider>(context);
    final size = MediaQuery.of(context).size;

    return Form(
      key: resetPass.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: FadeIn(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'nombre.apellido0000@alumnos.ubiobio.cl',
                labelText: 'Correo electrónico',
              ),
              onChanged: (value) => resetPass.email = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto';
                }

                if (value.length < 14 || value.length > 100) {
                  return 'El correo debe tener entre 14 y 100 caracteres';
                }

                RegExp emailUsuario =
                    RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
                if (!emailUsuario.hasMatch(value)) {
                  return 'El correo no es válido';
                }

                return null;
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppColors.primary,
              onPressed: resetPass.isLoading
                  ? null
                  : () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      final result =
                          await authService.resetPassword(resetPass.email);

                      if (result == null) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => DialogWidget(
                                  iconPath: 'email_icon',
                                  text:
                                      'Se ha enviado un correo para recuperar tu contraseña. Por favor, verifica tu bandeja de entrada.',
                                  onPressed: () => context.replace('/login'),
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => const DialogWidget(
                                  iconPath: 'warning_icon',
                                  text:
                                      'El correo electrónico ingresado no está registrado. Verifica que hayas ingresado la dirección correcta.',
                                ));
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resetPass.isLoading ? 'Espere...' : 'Solicitar',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
