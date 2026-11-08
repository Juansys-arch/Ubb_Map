class Validators {
  static String? validateEmail(String? value) {
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
      return 'El correo no es válido.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
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

