import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: 2, // AI 봇과 한 명의 친구를 위한 임시 데이터
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: const Text('AI 봇'),
              onTap: () {
                Navigator.of(context).pushNamed('/'); // AI 봇과 대화 화면으로 이동
              },
            );
          } else {
            return ListTile(
              title: const Text('친구 이름'), // 실제 친구의 이름으로 대체
              onTap: () {
                Navigator.of(context).pushNamed('/call'); // 친구와의 통화 화면으로 이동
              },
            );
          }
        },
      ),
    );
  }
}
