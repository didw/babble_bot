import 'package:flutter/material.dart';

class RobotFace extends StatelessWidget {
  const RobotFace({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.face,
          size: 200,
        ),
      ],
    );
  }
}
