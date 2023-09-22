import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TtsService {
  late String apiUrl; // 로딩된 후 초기화될 예정

  TtsService._();

  static Future<TtsService> create() async {
    var service = TtsService._();
    service.apiUrl = await service._loadApiUrl();
    return service;
  }

  Future<String> _loadApiUrl() async {
    // assets 디렉터리의 설정 파일에서 API URL을 가져옵니다.
    // JSON 파일에 {"tts_api_url": "http://your_flask_service_url/synthesize"} 형태로 저장되어 있어야 합니다.
    final jsonStr = await rootBundle.loadString('assets/config.json');
    final jsonMap = jsonDecode(jsonStr);
    print(jsonMap);
    return jsonMap['tts_api_url'] as String;
  }

  Future<Uint8List> synthesizeText(String text) async {
    final body = jsonEncode({"text": text});
    final headers = {"Content-Type": "application/json"};

    // HTTP POST 요청으로 TTS API 호출
    final response = await http.post(
      Uri.parse(apiUrl),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('TTS API 호출 실패');
    }
  }
}
