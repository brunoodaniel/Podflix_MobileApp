import 'package:flutter/material.dart';
import 'package:podflix/services/database_helper.dart';
import 'package:podflix/widgets/podcast_item.dart';

class FavoritesScreen extends StatefulWidget {
  final int userId;
  
  const FavoritesScreen({Key? key, required this.userId}) : super(key: key);
  
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _dbHelper.getFavorites(widget.userId);
      setState(() => _favorites = favorites);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar favoritos: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(String title) async {
    try {
      await _dbHelper.removeFavorite(widget.userId, title);
      await _loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removido dos favoritos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover favorito: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum podcast favoritado ainda!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final podcast = _favorites[index];
                      return PodcastItem(
                        imageUrl: podcast['image_path'],
                        title: podcast['title'],
                        description: podcast['description'],
                        publisher: podcast['publisher'] ?? 'Desconhecido',
                        date: podcast['date'],
                        isFavorite: true,
                        onFavoritePressed: () => _removeFavorite(podcast['title']),
                      );
                    },
                  ),
                ),
    );
  }
}