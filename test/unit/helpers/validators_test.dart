import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/helpers/validators.dart';

void main() {
  group('Validators - Pruebas Unitarias de Validación de Formulario', () {
    group('Validador de Correo Electrónico (validateEmail)', () {
      test('Retorna mensaje de error si el campo es nulo o vacío', () {
        expect(Validators.validateEmail(null), equals('Debes rellenar el campo de texto.'));
        expect(Validators.validateEmail(''), equals('Debes rellenar el campo de texto.'));
        expect(Validators.validateEmail('   '), equals('Debes rellenar el campo de texto.'));
      });

      test('Retorna mensaje de error si no cumple con la longitud mínima (<14) o máxima (>100)', () {
        // Menos de 14 caracteres
        expect(
          Validators.validateEmail('a@ubiobio.cl'),
          equals('El correo debe tener entre 14 y 100 caracteres.'),
        );

        // Más de 100 caracteres
        final emailLargo = '${'a' * 95}@ubiobio.cl';
        expect(
          Validators.validateEmail(emailLargo),
          equals('El correo debe tener entre 14 y 100 caracteres.'),
        );
      });

      test('Retorna mensaje de error si el formato o dominio no es válido (sin @, espacios, etc.)', () {
        // Sin @
        expect(
          Validators.validateEmail('juan.perezalumnos.ubiobio.cl'),
          equals('El correo no es válido.'),
        );

        // Dominio ajeno a la UBB (e.g. gmail.com)
        expect(
          Validators.validateEmail('juan.perez01@gmail.com'),
          equals('El correo no es válido.'),
        );

        // Con caracteres inválidos o espacios en el nombre
        expect(
          Validators.validateEmail('juan perez@ubiobio.cl'),
          equals('El correo no es válido.'),
        );
      });

      test('Retorna null para correos válidos de alumnos y funcionarios UBB', () {
        expect(Validators.validateEmail('estudiante.ubb@alumnos.ubiobio.cl'), isNull);
        expect(Validators.validateEmail('docente.ubb@ubiobio.cl'), isNull);
        expect(Validators.validateEmail('juan.perez2024@alumnos.ubiobio.cl'), isNull);
      });
    });

    group('Validador de Contraseña (validatePassword)', () {
      test('Retorna mensaje de error si es nula o vacía', () {
        expect(Validators.validatePassword(null), equals('Debes rellenar el campo de texto.'));
        expect(Validators.validatePassword(''), equals('Debes rellenar el campo de texto.'));
      });

      test('Retorna mensaje de error si tiene menos de 6 caracteres', () {
        expect(
          Validators.validatePassword('Abc1'),
          equals('La contraseña debe contener al menos 6 caracteres.'),
        );
      });

      test('Retorna mensaje de error si no contiene mayúsculas y minúsculas', () {
        // Solo minúsculas
        expect(
          Validators.validatePassword('abcdef123'),
          equals('Se requiere una letra mayúscula y una minúscula.'),
        );

        // Solo mayúsculas
        expect(
          Validators.validatePassword('ABCDEF123'),
          equals('Se requiere una letra mayúscula y una minúscula.'),
        );

        // Solo números y símbolos
        expect(
          Validators.validatePassword('12345678#'),
          equals('Se requiere una letra mayúscula y una minúscula.'),
        );
      });

      test('Retorna null para contraseñas válidas con longitud >= 6 y mayúscula/minúscula', () {
        expect(Validators.validatePassword('UbbPass2026'), isNull);
        expect(Validators.validatePassword('CampusMap1'), isNull);
        expect(Validators.validatePassword('aB3456'), isNull);
      });
    });
  });
}

