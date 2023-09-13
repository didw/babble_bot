import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'stt_service.dart';
import 'audio_service.dart'; // 오디오 처리 파일 import
import 'permission_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String transcribedText = "";
  late AudioService audioService;
  late File audioFile;
  late PermissionService permissionService;

  @override
  void initState() {
    super.initState();
    audioService = AudioService();
    _prepareAudioFile();
    permissionService = PermissionService();
  }

  Future<void> _startRecording() async {
    final micPermission = await permissionService.requestMicrophonePermission();
    final filePermission = await permissionService.requestFilePermission();

    if (micPermission && filePermission) {
      await audioService.startRecording(audioFile.path);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('권한 필요'),
          content: Text('녹음을 하려면 마이크와 파일 시스템 접근 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _prepareAudioFile() async {
    final directory = await getApplicationDocumentsDirectory();
    audioFile = File('${directory.path}/audio_sample.flac');
  }

  Future<void> _doTranscription() async {
    final sttService = SttService();
    final text = await sttService.transcribeAudio(audioFile);

    setState(() {
      transcribedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('STT 예제')),
      body: Center(
        child: Column(
          children: [
            Text(transcribedText), // 변환된 텍스트 출력
            ElevatedButton(
              onPressed: audioService.isRecording ? null : _startRecording,
              child: Text('STT 시작'),
            ),
            ElevatedButton(
              onPressed: audioService.isRecording
                  ? () async {
                      await audioService.stopRecording();
                      await _doTranscription();
                    }
                  : null,
              child: Text('STT 종료'),
            ),
          ],
        ),
      ),
    );
  }
}
