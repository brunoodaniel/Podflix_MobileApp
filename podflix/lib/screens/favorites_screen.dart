import 'package:flutter/material.dart';
import 'package:podflix/database_helper.dart';
import 'details_screen.dart';
import '../widgets/podcast_item.dart';

class FavoritesScreen extends StatefulWidget {
  final int userId;
  
  FavoritesScreen({required this.userId});
  
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favoritePodcasts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites(widget.userId);
    setState(() {
      _favoritePodcasts = favorites;
    });
  }

  Future<void> _removeFavorite(String title) async {
    await _dbHelper.removeFavorite(widget.userId, title);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcasts Favoritos'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: Container(
        color: Colors.blue[50],
        child: _favoritePodcasts.isEmpty
            ? Center(
                child: Text(
                  'Nenhum podcast favorito ainda!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _favoritePodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = _favoritePodcasts[index];

                  return PodcastItem(
                    imagePath: podcast['image_path'],
                    title: podcast['title'],
                    description: podcast['description'],
                    date: podcast['date'],
                    isFavorite: true,
                    onDetailsPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
                            title: podcast['title'],
                            imagePath: podcast['image_path'],
                            description: podcast['description'],
                            date: podcast['date'],
                            onFavorite: () => _removeFavorite(podcast['title']),
                            onMark: () {},
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    onFavoritePressed: () => _removeFavorite(podcast['title']),
                  );
                },
              ),
      ),
    );
  }
}