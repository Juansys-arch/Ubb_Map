import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/screens/screens.dart';

class LoadingScreenLC extends StatelessWidget {
  const LoadingScreenLC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted ? const MapScreenLC() : const GpsAccessScreen();
      },
    ));
  }
}
