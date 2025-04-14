import 'package:flutter/material.dart';
import 'package:podflix/services/api_service.dart';
import 'package:podflix/services/database_helper.dart';
import 'package:podflix/widgets/podcast_item.dart';
import 'package:podflix/screens/favorites_screen.dart';
import 'package:podflix/screens/marked_screen.dart';
import 'package:podflix/screens/login_screen.dart';
import 'package:podflix/screens/confirmation_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  
  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _podcasts = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _marked = [];
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.text = 'tecnologia';
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadFavorites();
    await _loadMarked();
    await _loadInitialPodcasts();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites(widget.userId);
    setState(() => _favorites = favorites);
  }

  Future<void> _loadMarked() async {
    final marked = await _dbHelper.getMarked(widget.userId);
    setState(() => _marked = marked);
  }

  Future<void> _loadInitialPodcasts() async {
    try {
      final results = await ApiService.searchPodcasts(_searchController.text, page: 1);
      setState(() => _podcasts = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleFavorite(Map<String, dynamic> podcast) async {
    final isFavorite = _favorites.any((p) => p['title'] == podcast['title']);
    
    if (isFavorite) {
      await _dbHelper.removeFavorite(widget.userId, podcast['title']);
    } else {
      await _dbHelper.insertFavorite(widget.userId, podcast);
    }
    
    await _loadFavorites();
  }

  Future<void> _toggleMarked(Map<String, dynamic> podcast) async {
  final isMarked = _marked.any((p) => p['title'] == podcast['title']);
  
  if (isMarked) {
    await _dbHelper.removeMarked(widget.userId, podcast['title']);
    await _loadMarked();
  } else {
    await _dbHelper.insertMarked(widget.userId, podcast);
    await _loadMarked();
    
    // Navega para a tela de confirmação com os dados do podcast
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          title: podcast['title'] ?? 'Título não disponível',
          imagePath: podcast['imageUrl'] ?? 'assets/default_podcast.png',
          description: podcast['description'] ?? 'Descrição não disponível',
          date: podcast['date'] ?? 'Data não disponível',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podflix'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesScreen(userId: widget.userId),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarkedScreen(userId: widget.userId),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Podcasts',
                hintText: 'Digite um tema ou título',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadInitialPodcasts();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _loadInitialPodcasts(),
            ),
          ),

          // Conteúdo central
          Expanded(
            child: Center(
              child: _podcasts.isEmpty
                  ? const Text('Nenhum podcast encontrado')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Carrossel
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.8,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _podcasts.length,
                            onPageChanged: (index) {
                              setState(() => _currentIndex = index);
                            },
                            itemBuilder: (context, index) {
                              final podcast = _podcasts[index];
                              final isFavorite = _favorites.any((p) => p['title'] == podcast['title']);
                              final isMarked = _marked.any((p) => p['title'] == podcast['title']);
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: PodcastItem(
                                  imageUrl: podcast['imageUrl'],
                                  title: podcast['title'],
                                  description: podcast['description'],
                                  publisher: podcast['publisher'] ?? 'Desconhecido',
                                  date: podcast['date'],
                                  isFavorite: isFavorite,
                                  isMarked: isMarked,
                                  onFavoritePressed: () => _toggleFavorite(podcast),
                                  onMarkPressed: () => _toggleMarked(podcast),
                                ),
                              );
                            },
                          ),
                        ),

                        // Indicadores
                        Container(
                          height: 30,
                          padding: const EdgeInsets.only(top: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _podcasts.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index 
                                    ? const Color.fromARGB(255, 100, 172, 255)
                                    : Colors.grey[300],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}