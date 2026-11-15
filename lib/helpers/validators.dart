class Validators {
  static String? validateEmail(String? value) {
    final email = value?.trim().toLowerCase() ?? '';
    if (email.isEmpty) {
      return 'Debes rellenar el campo de texto.';
    }

    if (email.length < 14 || email.length > 100) {
      return 'El correo debe tener entre 14 y 100 caracteres.';
    }

    final emailPattern =
        RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
    if (!emailPattern.hasMatch(email)) {
      return 'El correo no es válido.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Debes rellenar el campo de texto.';
    }

    if (password.length < 6) {
      return 'La contraseña debe contener al menos 6 caracteres.';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    if (!hasUppercase || !hasLowercase) {
      return 'Se requiere una letra mayúscula y una minúscula.';
    }

    return null;
  }
}

String? validateEmail(String? value) => Validators.validateEmail(value);

String? validatePassword(String? value) => Validators.validatePassword(value);
