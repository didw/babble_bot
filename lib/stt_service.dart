import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SttService {
  late String apiUrl; // 로딩된 후 초기화될 예정

  SttService() {
    _loadApiUrl().then((url) {
      apiUrl = url; // 이 부분은 Flask 서비스의 URL을 설정합니다.
    });
  }

  Future<String> _loadApiUrl() async {
    // assets 디렉터리의 설정 파일에서 API URL을 가져옵니다.
    // JSON 파일에 {"api_url": "http://your_flask_service_url/transcribe"} 형태로 저장되어 있어야 합니다.
    final jsonStr = await rootBundle.loadString('assets/config.json');
    final jsonMap = jsonDecode(jsonStr);
    return jsonMap['api_url'] as String;
  }

  Future<String> transcribeAudio(File audioFile) async {
    // Multipart HTTP 요청을 위한 준비
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    var audioPart = http.MultipartFile.fromBytes(
        'file', await audioFile.readAsBytes(),
        filename: 'audio.wav');

    request.files.add(audioPart);

    // HTTP POST 요청으로 STT API 호출
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final result = jsonDecode(responseBody);
      // results는 일반적으로 여러 transcript를 가질 수 있으므로 첫 번째 것만 반환합니다.
      return result['transcripts'][0];
    } else {
      throw Exception('STT API 호출 실패');
    }
  }
}
