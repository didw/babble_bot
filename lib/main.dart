import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/call_screen.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/chat_service.dart';
import 'services/permission_service.dart';
import 'services/stt_service.dart';
import 'services/tts_service.dart';
import 'widgets/chat_log_list_tile.dart';
import 'widgets/recording_button.dart';
import 'widgets/robot_face.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home', // 초기 화면을 home_screen으로 설정
      routes: {
        '/home': (context) => const MyHomePage(),
        '/call': (context) => const CallScreen(),
      },
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
  late TtsService ttsService;
  List<Map<String, String>> chatLogs = [];
  bool showRobotFace = false;

  late RobotFace robotFace;

  void toggleView() {
    setState(() {
      showRobotFace = !showRobotFace; // 상태를 토글합니다.
    });
  }

  @override
  void initState() {
    super.initState();
    robotFace = const RobotFace();
    audioService = AudioService();
    _prepareAudioFile();
    permissionService = PermissionService();
    _initChatService();
  }

  @override
  void dispose() {
    // 여기에 필요한 리소스 해제 로직 추가
    audioService.dispose(); // 예시: audioService에 dispose 메서드가 있다면 호출
    super.dispose();
  }

  Future<void> _initChatService() async {
    try {
      chatService = await ChatService.create();
    } catch (e) {
      print("ChatService 초기화 오류: $e");
      // 사용자에게 오류 메시지를 보여줄 수도 있습니다.
    }
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
    chatLogs.add({'role': 'user', 'content': userText});
    List<Map<String, String>> messages = [
      {
        "role": "system",
        "content":
            "You are a casual chatbot that likes to discuss movies, music, and general pop culture. You use slang to keep the conversation fun and light. And don't use emojis because response is used in google tts. response sentence less then 50 words."
      },
    ];
    messages.addAll(chatLogs);
    print(messages);
    String assistantResponse = await chatService.fetchChatResponse(messages);
    chatLogs.add({'role': 'assistant', 'content': assistantResponse});
    if (chatLogs.length > 10) {
      chatLogs.removeAt(0);
      chatLogs.removeAt(0);
    }
    setState(() {});
    _speak(assistantResponse);
  }

  Future<void> _speak(String text) async {
    final ttsService = await TtsService.create();
    try {
      Uint8List audioData = await ttsService.synthesizeText(text);

      final directory = await getApplicationDocumentsDirectory();
      final audioFilePath = '${directory.path}/tts_audio.wav';

      await audioService.playTtsAudio(audioData, audioFilePath);
    } catch (e) {
      print("TTS API 호출 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다아라'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushNamed('/home'); // home_screen으로 이동
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: !showRobotFace,
                  child: ChatLogList(chatLogs),
                ),
                Visibility(
                  visible: showRobotFace,
                  child: const RobotFace(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: toggleView,
                  child: Text(showRobotFace ? "텍스트 보기" : "로봇 얼굴 보기"),
                ),
                const Spacer(), // 여기에 Spacer 추가
                RecordingButton(
                  onStartRecording: _startRecording,
                  onStopRecording: () async {
                    await audioService.stopRecording();
                    await _doTranscription();
                  },
                  onFetchResponse: () async {
                    await _fetchChatResponse(transcribedText);
                  },
                ),
                const Spacer(), // 여기에 Spacer 추가
                ElevatedButton(
                  onPressed: () {
                    chatLogs.clear();
                    setState(() {});
                  },
                  child: const Text("Clear"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
