import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SttService {
  late String apiUrl; // API 키가 로딩된 후 초기화될 예정

  SttService() {
    _loadApiKey().then((key) {
      apiUrl = "https://speech.googleapis.com/v1/speech:recognize?key=$key";
    });
  }

  Future<String> _loadApiKey() async {
    final jsonStr =
        await rootBundle.loadString('assets/google_api_service.json');
    final jsonMap = jsonDecode(jsonStr);
    return jsonMap['private_key'] as String;
  }

  Future<String> transcribeAudio(File audioFile) async {
    // 오디오 파일을 base64로 인코딩
    final audioBytes = await audioFile.readAsBytes();
    final base64Audio = base64Encode(audioBytes);

    // POST 요청을 위한 JSON 생성
    final requestPayload = jsonEncode({
      'audio': {'content': base64Audio},
      'config': {
        'encoding': 'LINEAR16',
        'languageCode': 'ko-KR',
        'sampleRateHertz': 16000,
      },
    });

    // HTTP POST 요청으로 STT API 호출
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: requestPayload,
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['results'][0]['alternatives'][0]['transcript'];
    } else {
      throw Exception('STT API 호출 실패');
    }
  }
}
