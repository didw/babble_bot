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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          // 불빛 깜빡임을 시뮬레이션하기 위해 색상을 변경
          color: _animation.value > 0.5 ? Colors.red : Colors.blue,
          width: 100,
          height: 100,
          // 여기에 로봇 얼굴 UI를 추가할 수 있습니다.
          child: Icon(
            Icons.face, // 로봇 얼굴을 표현하는 아이콘입니다. 원하시는 이미지로 교체 가능합니다.
            size: 200,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
