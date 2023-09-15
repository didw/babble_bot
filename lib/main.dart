import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'stt_service.dart';
import 'audio_service.dart'; // 오디오 처리 파일 import
import 'permission_service.dart'; // 권한 처리 파일 import
import 'chat_service.dart'; // 챗봇 API 처리 파일
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
  late ChatService chatService;
  List<Map<String, dynamic>> chatLogs = [];

  @override
  void initState() {
    super.initState();
    audioService = AudioService();
    _prepareAudioFile();
    permissionService = PermissionService();
    _initChatService();
  }

  Future<void> _initChatService() async {
    chatService = await ChatService.create(); // NEW
  }

  Future<void> _prepareAudioFile() async {
    final directory = await getApplicationDocumentsDirectory();
    audioFile = File('${directory.path}/audio_sample.wav');
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

  Future<void> _doTranscription() async {
    setState(() {});
    final sttService = await SttService.create();
    String text = "";
    try {
      text = await sttService.transcribeAudio(audioFile);
    } catch (e) {
      if (e.toString() == "Exception: STT 결과 없음") {
        print("STT 결과 없음");
        text = ""; // STT 결과가 없을 때는 공백을 반환
      } else {
        // 그 외의 예외를 처리 (필요하다면)
      }
    }
    print("STT 결과: $text");
    setState(() {
      transcribedText = text;
    });
  }

  Future<void> _fetchChatResponse(String userText) async {
    List<Map<String, String>> messages = [
      {
        "role": "system",
        "content":
            "You are a casual chatbot that likes to discuss movies, music, and general pop culture. You use slang and emojis to keep the conversation fun and light."
      },
      {"role": "user", "content": userText}
    ];
    String assistantResponse = await chatService.fetchChatResponse(messages);
    chatLogs.add({'role': 'user', 'content': userText});
    chatLogs.add({'role': 'assistant', 'content': assistantResponse});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STT and Chat Example')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatLogs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatLogs[index]['content']),
                  leading: chatLogs[index]['role'] == 'user'
                      ? Icon(Icons.person_outline)
                      : null,
                  trailing: chatLogs[index]['role'] == 'assistant'
                      ? Icon(Icons.assistant)
                      : null,
                );
              },
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: audioService.recordState != RecordState.record
                    ? _startRecording
                    : null,
                child: const Text('STT Start'),
              ),
              ElevatedButton(
                onPressed: audioService.recordState == RecordState.record
                    ? () async {
                        await audioService.stopRecording();
                        await _doTranscription();
                        await _fetchChatResponse(transcribedText);
                      }
                    : null,
                child: const Text('STT Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
