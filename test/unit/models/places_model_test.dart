import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/models/places_model.dart';

void main() {
  group('Feature.fromMap - Pruebas Unitarias', () {
    test('Parsea exitosamente un mapa completo de lugar (Campus Fernando May)', () {
      final Map<String, dynamic> completeData = {
        'id': 'poi_fernando_may_01',
        'placetype': ['poi', 'campus'],
        'text': 'Campus Fernando May',
        'placeName': ['Universidad del Bío-Bío', 'Chillán', 'Chile'],
        'center': [-72.0833, -36.5986],
        'facultad': 'Facultad de Ciencias de la Salud y de los Alimentos',
        'carreras': ['Enfermería', 'Nutrición y Dietética', 'Fonoaudiología'],
        'imagen': 'https://ubiobio.cl/fernando_may.jpg',
      };

      final feature = Feature.fromMap(completeData);

      expect(feature.id, equals('poi_fernando_may_01'));
      expect(feature.text, equals('Campus Fernando May'));
      expect(feature.placeType, equals(['poi', 'campus']));
      expect(feature.placeName, contains('Universidad del Bío-Bío'));
      expect(feature.center, equals([-72.0833, -36.5986]));
      expect(feature.facultad, equals('Facultad de Ciencias de la Salud y de los Alimentos'));
      expect(feature.carreras?.length, equals(3));
      expect(feature.imagen, equals('https://ubiobio.cl/fernando_may.jpg'));
    });

    test('No lanza excepción con mapa vacío y asigna valores por defecto seguros', () {
      final Map<String, dynamic> emptyData = {};

      expect(() => Feature.fromMap(emptyData), returnsNormally);

      final feature = Feature.fromMap(emptyData);
      expect(feature.id, isEmpty);
      expect(feature.text, isEmpty);
      expect(feature.placeType, isEmpty);
      expect(feature.placeName, isEmpty);
      expect(feature.center, isEmpty);
      expect(feature.facultad, isNull);
      expect(feature.carreras, isNull);
      expect(feature.imagen, isNull);
    });

    test('No lanza excepción con campos que contienen valores nulos', () {
      final Map<String, dynamic> nullFieldsData = {
        'id': null,
        'placetype': null,
        'text': null,
        'placeName': null,
        'center': null,
        'facultad': null,
        'carreras': null,
        'imagen': null,
      };

      expect(() => Feature.fromMap(nullFieldsData), returnsNormally);

      final feature = Feature.fromMap(nullFieldsData);
      expect(feature.id, isEmpty);
      expect(feature.text, isEmpty);
      expect(feature.placeType, isEmpty);
      expect(feature.placeName, isEmpty);
      expect(feature.center, isEmpty);
      expect(feature.facultad, isNull);
      expect(feature.carreras, isNull);
      expect(feature.imagen, isNull);
    });

    test('Serialización toMap y toJson conserva los datos esenciales', () {
      final originalFeature = Feature(
        id: '123',
        placeType: const ['lugar'],
        text: 'Aulas A',
        placeName: const ['Edificio Aulas'],
        center: const [-72.0, -36.0],
        facultad: 'Ingeniería',
      );

      final map = originalFeature.toMap();
      final reconstructed = Feature.fromMap(map);

      expect(reconstructed.id, equals(originalFeature.id));
      expect(reconstructed.text, equals(originalFeature.text));
      expect(reconstructed.facultad, equals(originalFeature.facultad));
      expect(reconstructed.center, equals(originalFeature.center));
    });
  });
}

