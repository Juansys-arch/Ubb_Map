import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/location/location_bloc.dart';

void main() {
  group('LocationBloc - Pruebas Unitarias', () {
    late LocationBloc locationBloc;

    setUp(() {
      locationBloc = LocationBloc();
    });

    tearDown(() {
      locationBloc.close();
    });

    test('El estado inicial tiene valores por defecto correctos', () {
      expect(locationBloc.state.followingUser, isFalse);
      expect(locationBloc.state.lastKnowLocation, isNull);
      expect(locationBloc.state.myLocationHistory, isEmpty);
    });

    blocTest<LocationBloc, LocationState>(
      'OnNewUserLocationEvent actualiza la última ubicación y añade la coordenada al historial',
      build: () => LocationBloc(),
      act: (bloc) => bloc.add(const OnNewUserLocationEvent(LatLng(-36.5986, -72.0833))),
      expect: () => [
        isA<LocationState>()
            .having((s) => s.lastKnowLocation, 'lastKnowLocation', const LatLng(-36.5986, -72.0833))
            .having((s) => s.myLocationHistory, 'myLocationHistory', [const LatLng(-36.5986, -72.0833)])
            .having((s) => s.followingUser, 'followingUser', isFalse),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'Múltiples OnNewUserLocationEvent acumulan secuencialmente el historial de ubicaciones',
      build: () => LocationBloc(),
      act: (bloc) {
        bloc.add(const OnNewUserLocationEvent(LatLng(-36.5980, -72.0830)));
        bloc.add(const OnNewUserLocationEvent(LatLng(-36.5990, -72.0840)));
      },
      expect: () => [
        // Primer evento
        isA<LocationState>()
            .having((s) => s.lastKnowLocation, 'lastKnowLocation', const LatLng(-36.5980, -72.0830))
            .having((s) => s.myLocationHistory.length, 'history length', 1),
        // Segundo evento
        isA<LocationState>()
            .having((s) => s.lastKnowLocation, 'lastKnowLocation', const LatLng(-36.5990, -72.0840))
            .having((s) => s.myLocationHistory.length, 'history length', 2)
            .having((s) => s.myLocationHistory, 'myLocationHistory', [
              const LatLng(-36.5980, -72.0830),
              const LatLng(-36.5990, -72.0840),
            ]),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'OnStartFollowingUser y OnStopFollowingUser modifican followingUser',
      build: () => LocationBloc(),
      act: (bloc) {
        bloc.add(OnStartFollowingUser());
        bloc.add(OnStopFollowingUser());
      },
      expect: () => [
        isA<LocationState>().having((s) => s.followingUser, 'followingUser', isTrue),
        isA<LocationState>().having((s) => s.followingUser, 'followingUser', isFalse),
      ],
    );
  });
}

