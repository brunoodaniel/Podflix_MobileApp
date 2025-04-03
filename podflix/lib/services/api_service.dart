import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://listen-api.listennotes.com/api/v2';
  static const String _apiKey = '78545fb6daf04facb8d8a8955e4b6d9d'; // Substitua pela sua chave

  static Future<List<Map<String, dynamic>>> searchPodcasts(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=$query&type=podcast&page=$page'),
      headers: {'X-ListenAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results'].map((podcast) {
        return {
          'id': podcast['id'],
          'title': podcast['title_original'],
          'description': podcast['description_original'],
          'imageUrl': podcast['image'],
          'publisher': podcast['publisher_original'],
          'audioUrl': podcast['listennotes_url'],
          'date': _formatDate(podcast['latest_pub_date_ms']),
        };
      }).toList());
    } else {
      throw Exception('Falha ao carregar podcasts. Status: ${response.statusCode}');
    }
  }

  static String _formatDate(int? ms) {
    if (ms == null) return 'Data desconhecida';
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${date.day}/${date.month}/${date.year}';
  }
}