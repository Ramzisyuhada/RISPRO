import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "WRZPeApzPupgXFip9EcvMfrt5Hk7OMTy";
  static const String baseUrl = "https://api.mistral.ai/v1/chat/completions";

   Future<String> generateScene(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "mistral-small",
        "messages": [
          {
            "role": "system",
            "content":
                "Kamu adalah AI untuk simulasi manajemen risiko proyek publik."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "temperature": 0.9
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception("Gagal AI");
    }
  }
}