import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base da API e chave de autenticação
  static const String _baseUrl = 'https://listen-api.listennotes.com/api/v2';
  static const String _apiKey = '78545fb6daf04facb8d8a8955e4b6d9d';

  // Método principal que faz a busca de podcasts
  static Future<List<Map<String, dynamic>>> searchPodcasts(String query, {int page = 1}) async {
    // Faz a requisição GET para a API
    final response = await http.get(
      // Constrói a URL com os parâmetros de busca (query, tipo podcast e página)
      Uri.parse('$_baseUrl/search?q=$query&type=podcast&page=$page'),
      // Adiciona o cabeçalho com a chave de API
      headers: {'X-ListenAPI-Key': _apiKey},
    );

    // Se a resposta for bem-sucedida (status 200)
    if (response.statusCode == 200) {
      // Decodifica o JSON da resposta
      final data = json.decode(response.body);
      
      // Mapeia os resultados para um formato mais simples
      return List<Map<String, dynamic>>.from(data['results'].map((podcast) {
        return {
          'id': podcast['id'],
          'title': podcast['title_original'],          // Título original do podcast
          'description': podcast['description_original'], // Descrição original
          'imageUrl': podcast['image'],               // URL da imagem
          'publisher': podcast['publisher_original'], // Editora/origem
          'audioUrl': podcast['listennotes_url'],     // URL para ouvir
          'date': _formatDate(podcast['latest_pub_date_ms']), // Data formatada
        };
      }).toList());
    } else {
      // Se houver erro, lança uma exceção
      throw Exception('Falha ao carregar podcasts. Status: ${response.statusCode}');
    }
  }

  // Método auxiliar para formatar a data a partir de milissegundos
  static String _formatDate(int? ms) {
    if (ms == null) return 'Data desconhecida';
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${date.day}/${date.month}/${date.year}';
  }
}