import 'package:flutter_test/flutter_test.dart';
import 'package:ubb/blocs/gps/gps_bloc.dart';

void main() {
  group('GpsState - Pruebas Unitarias', () {
    test('isAllGranted retorna true solo si GPS está activo Y permiso concedido', () {
      // Caso 1: Ambos en false -> false
      const state1 = GpsState(isGpsEnabled: false, isGpsPermissionGranted: false);
      expect(state1.isAllGranted, isFalse);

      // Caso 2: GPS activo pero sin permiso -> false
      const state2 = GpsState(isGpsEnabled: true, isGpsPermissionGranted: false);
      expect(state2.isAllGranted, isFalse);

      // Caso 3: GPS inactivo pero con permiso -> false
      const state3 = GpsState(isGpsEnabled: false, isGpsPermissionGranted: true);
      expect(state3.isAllGranted, isFalse);

      // Caso 4: GPS activo y permiso concedido -> true
      const state4 = GpsState(isGpsEnabled: true, isGpsPermissionGranted: true);
      expect(state4.isAllGranted, isTrue);
    });

    test('copyWith crea una nueva instancia sin mutar el estado original', () {
      const originalState = GpsState(
        isGpsEnabled: false,
        isGpsPermissionGranted: false,
      );

      // Modificamos solo isGpsEnabled
      final updatedState = originalState.copyWith(isGpsEnabled: true);

      // Verificamos que el original permanezca inmutable
      expect(originalState.isGpsEnabled, isFalse);
      expect(originalState.isGpsPermissionGranted, isFalse);

      // Verificamos los valores del nuevo estado
      expect(updatedState.isGpsEnabled, isTrue);
      expect(updatedState.isGpsPermissionGranted, isFalse);

      // Modificamos solo isGpsPermissionGranted
      final permissionUpdatedState = originalState.copyWith(isGpsPermissionGranted: true);
      expect(permissionUpdatedState.isGpsEnabled, isFalse);
      expect(permissionUpdatedState.isGpsPermissionGranted, isTrue);

      // copyWith sin argumentos preserva los valores
      final clonedState = originalState.copyWith();
      expect(clonedState, equals(originalState));
    });

    test('Comparación de igualdad por Equatable', () {
      const stateA = GpsState(isGpsEnabled: true, isGpsPermissionGranted: true);
      const stateB = GpsState(isGpsEnabled: true, isGpsPermissionGranted: true);
      const stateC = GpsState(isGpsEnabled: true, isGpsPermissionGranted: false);

      expect(stateA, equals(stateB));
      expect(stateA == stateC, isFalse);
    });
  });
}

