import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class MapsOptionsScreen extends StatelessWidget {
  const MapsOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            MapsOptions(),
          ],
        ),
      ),
    );
  }
}
