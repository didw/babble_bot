import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('통화 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // home_screen으로 돌아갑니다.
          },
          child: const Text('종료'),
        ),
      ),
    );
  }
}
