import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ubb/providers/login_form_provider.dart';
import 'package:ubb/themes/colors_theme.dart';
import 'package:ubb/ui/input_decorations.dart';
import 'package:ubb/ui/ui.dart';
import 'package:ubb/widgets/dialog_widget.dart';

import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                height:
                    isKeyboardVisible ? size.height * 0.15 : size.height * 0.25,
                child: Container(
                  height: size.height * 0.35,
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
                        'assets/icons/login_icon.svg',
                        height: isKeyboardVisible
                            ? size.height * 0.07
                            : size.height * 0.15,
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.03),
                    Text(
                      'Iniciar Sesión',
                      style: GoogleFonts.roboto(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
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
              onPressed: () => context.replace('/register'),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(
                  AppColors.textPrimary.withOpacity(0.1),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: AppColors.textPrimary.withOpacity(0.8),
                  ),
                  children: [
                    TextSpan(
                      text: '¿Aún no tienes cuenta? ',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'Registrarse',
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
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final size = MediaQuery.of(context).size;
    return Form(
      key: loginForm.formKey,
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
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto.';
                }

                if (value.length < 14 || value.length > 100) {
                  return 'El correo debe tener entre 14 y 100 caracteres.';
                }

                RegExp emailUsuario =
                    RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
                if (!emailUsuario.hasMatch(value)) {
                  return 'El correo no es válido.';
                }

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
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar el campo de texto.';
                }

                if (value.length < 6) {
                  return 'La contraseña debe contener al menos 6 caracteres.';
                }

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

                return 'Se requiere una letra mayúscula y una minúscula.';
              },
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () => context.replace('/reset_password'),
              style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                      AppColors.primary.withOpacity(0.1)),
                  shape: WidgetStateProperty.all(const StadiumBorder())),
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: GoogleFonts.roboto(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(text: '¿Has olvidado tu contraseña? '),
                    TextSpan(
                      text: 'Recuperar',
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
            SizedBox(
              height: size.height * 0.03,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppColors.primary,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final String? errorMessage = await authService.login(
                          loginForm.email, loginForm.password);
                      if (errorMessage == null) {
                        context.replace('/home');
                      } else {
                        showDialog<void>(
                          builder: (context) => const DialogWidget(
                            text:
                                'El correo electrónico o la contraseña son incorrectos. Verifica tus credenciales e intenta nuevamente.',
                            iconPath: 'warning_icon',
                          ),
                          context: context,
                        );

                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginForm.isLoading ? 'Espere...' : 'Ingresar',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
