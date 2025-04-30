import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey =
    'sua_api_key'; // Substitua pela sua chave da API do Gemini

Future<String> getTravelInfo(String prompt) async {
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['candidates'][0]['content']['parts'][0]['text'];
  } else {
    throw Exception('Erro ao acessar Gemini: ${response.body}');
  }
}
