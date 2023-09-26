import 'package:flutter/material.dart';

class RobotFace extends StatelessWidget {
  const RobotFace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/daara.jpeg',
        width: 400,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
