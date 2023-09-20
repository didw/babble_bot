import 'package:flutter/material.dart';

class RobotFace extends StatefulWidget {
  RobotFace();

  @override
  _RobotFaceState createState() => _RobotFaceState();
}

class _RobotFaceState extends State<RobotFace>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
  }

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

  @override
  void dispose() {
    super.dispose();
  }
}
