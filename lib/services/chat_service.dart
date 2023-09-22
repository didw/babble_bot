import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ChatService {
  late String apiUrl; // Initialized after loading

  ChatService._();

  static Future<ChatService> create() async {
    var service = ChatService._();
    service.apiUrl = await service._loadApiUrl();
    return service;
  }

  Future<String> _loadApiUrl() async {
    // Load the API URL from the assets directory's config file.
    final jsonStr = await rootBundle.loadString('assets/config.json');
    final jsonMap = jsonDecode(jsonStr);
    return jsonMap['chat_api_url'] as String;
  }

  Future<String> fetchChatResponse(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'messages': messages}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data["response"] ?? "";
    } else {
      throw Exception("Failed to fetch chat response");
    }
  }
}
