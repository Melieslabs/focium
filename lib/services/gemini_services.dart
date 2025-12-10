import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyCWdP0gtL6_oETzxq6XHoCmy1eBQrdriAU"; // Replace only this

  Future<String> askGemini(String prompt) async {
  final url = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_API_KEY',
)
;


    final body = {
      "contents": [
        {
          "parts": [
            {"text":prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final output = data["candidates"]?[0]["content"]?["parts"]?[0]["text"];
      return output ?? "No response";
    } else {
      return "API Error: ${response.statusCode}\n${response.body}";
    }
  }
}
