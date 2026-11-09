class Validators {
  static String? validateEmail(String? value) {
<<<<<<< HEAD
    if (value == null || value.trim().isEmpty) {
      return 'Debes rellenar el campo de texto.';
    }

    final trimmed = value.trim();
    if (trimmed.length < 14 || trimmed.length > 100) {
      return 'El correo debe tener entre 14 y 100 caracteres.';
    }

    final RegExp emailUsuario =
        RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
    if (!emailUsuario.hasMatch(trimmed.toLowerCase())) {
=======
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Debes rellenar el campo de texto.';
    }

    if (email.length < 14 || email.length > 100) {
      return 'El correo debe tener entre 14 y 100 caracteres.';
    }

    final emailPattern =
        RegExp(r'^[a-z0-9.]+@(alumnos\.ubiobio\.cl|ubiobio\.cl)$');
    if (!emailPattern.hasMatch(email)) {
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
      return 'El correo no es válido.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
<<<<<<< HEAD
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
  }
}

// Funciones libres para máxima compatibilidad
String? validateEmail(String? value) => Validators.validateEmail(value);
String? validatePassword(String? value) => Validators.validatePassword(value);

=======
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
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
