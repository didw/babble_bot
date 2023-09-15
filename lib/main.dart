import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'stt_service.dart';
import 'audio_service.dart'; // 오디오 처리 파일 import
import 'permission_service.dart'; // 권한 처리 파일 import
import 'package:record/record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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

  Future<void> _prepareAudioFile() async {
    final directory = await getApplicationDocumentsDirectory();
    audioFile = File('${directory.path}/audio_sample.wav');
  }

  Future<void> _doTranscription() async {
    setState(() {});
    final sttService = SttService();
    final text = await sttService.transcribeAudio(audioFile);

    setState(() {
      transcribedText = text;
    });
  }

  Future<void> _startRecording() async {
    final micPermission = await permissionService.requestMicrophonePermission();
    final filePermission = await permissionService.requestFilePermission();

    if (micPermission && filePermission) {
      await audioService.startRecording(audioFile.path);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('권한 필요'),
          content: const Text('녹음을 하려면 마이크와 파일 시스템 접근 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STT 예제')),
      body: Center(
        child: Column(
          children: [
            Text(transcribedText), // 변환된 텍스트 출력
            ElevatedButton(
              onPressed: audioService.recordState != RecordState.record
                  ? _startRecording
                  : null,
              child: const Text('STT 시작'),
            ),
            ElevatedButton(
              onPressed: audioService.recordState == RecordState.record
                  ? () async {
                      await audioService.stopRecording();
                      await _doTranscription();
                    }
                  : null,
              child: const Text('STT 종료'),
            ),
          ],
        ),
      ),
    );
  }
}
