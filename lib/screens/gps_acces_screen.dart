import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc.dart';
import '../widgets/widgets.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade100,
        child: Center(
          child: BlocBuilder<GpsBloc, GpsState>(
            builder: (context, state) {
              return const GpsAccessContent();
            },
          ),
        ),
      ),
    );
  }
}
