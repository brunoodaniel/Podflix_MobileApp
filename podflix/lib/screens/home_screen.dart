import 'package:flutter/material.dart';
import 'package:podflix/services/api_service.dart';
import 'package:podflix/services/database_helper.dart';
import 'package:podflix/widgets/podcast_item.dart';
import 'package:podflix/screens/favorites_screen.dart';
import 'package:podflix/screens/marked_screen.dart';
import 'package:podflix/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  
  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _podcasts = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _marked = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = 'tecnologia';
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
    setState(() {
      _isLoading = true;
      _podcasts = [];
      _currentPage = 1;
      _hasMore = true;
    });

    try {
      final results = await ApiService.searchPodcasts(_searchController.text, page: 1);
      setState(() => _podcasts = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMorePodcasts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final results = await ApiService.searchPodcasts(
        _searchController.text, 
        page: _currentPage + 1
      );

      if (results.isEmpty) {
        setState(() => _hasMore = false);
      } else {
        setState(() {
          _podcasts.addAll(results);
          _currentPage++;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar mais podcasts')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMorePodcasts();
    }
  }

  Future<void> _refreshData() async {
    await _loadInitialPodcasts();
    await _loadFavorites();
    await _loadMarked();
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
    } else {
      await _dbHelper.insertMarked(widget.userId, podcast);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Podcast marcado com sucesso!')),
      );
    }
    
    await _loadMarked();
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
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
            Expanded(
              child: _isLoading && _podcasts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _podcasts.isEmpty
                      ? const Center(child: Text('Nenhum podcast encontrado'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _podcasts.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _podcasts.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            
                            final podcast = _podcasts[index];
                            final isFavorite = _favorites.any((p) => p['title'] == podcast['title']);
                            final isMarked = _marked.any((p) => p['title'] == podcast['title']);
                            
                            return PodcastItem(
                              imageUrl: podcast['imageUrl'],
                              title: podcast['title'],
                              description: podcast['description'],
                              publisher: podcast['publisher'],
                              date: podcast['date'],
                              isFavorite: isFavorite,
                              isMarked: isMarked,
                              onFavoritePressed: () => _toggleFavorite(podcast),
                              onMarkPressed: () => _toggleMarked(podcast),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}