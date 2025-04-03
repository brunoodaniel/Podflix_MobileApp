import 'package:flutter/material.dart';
import 'package:podflix/database_helper.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';
import 'marked_screen.dart';
import 'login_screen.dart';
import 'confirmation_screen.dart';
import '../widgets/podcast_item.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  
  HomeScreen({required this.userId});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> podcasts = [
    {
      'imagePath': 'assets/podcast1.png',
      'title': 'Código Aberto: Tecnologia e Sociedade',
      'description': 'Explore os mistérios da mente humana, da neurociência à filosofia. Convidados especiais discutem como pensamos, sentimos e criamos. Uma jornada para entender o que nos torna quem somos.',
      'date': '15/10/2025',
    },
    {
      'imagePath': 'assets/podcast2.png',
      'title': 'Diário de um Viajante',
      'description': 'Acompanhe as aventuras e reflexões de um viajante pelo mundo. Histórias reais, culturas fascinantes e lições de vida que vão além do mapa.',
      'date': '11/05/2025',
    },
    {
      'imagePath': 'assets/podcast3.png',
      'title': 'Sons e Sentidos',
      'description': 'Um mergulho na música, explorando gêneros, histórias por trás das canções e entrevistas com artistas. Para quem ama sentir a vida em forma de melodia.',
      'date': '01/08/2025',
    },
    {
      'imagePath': 'assets/podcast4.png',
      'title': 'Rádio Viva: O Som da Nostalgia',
      'description': 'Reviva a magia do rádio com programas clássicos, histórias marcantes e trilhas sonoras que marcaram épocas. Um tributo à era de ouro do rádio.',
      'date': '28/04/2025',
    },
    {
      'imagePath': 'assets/podcast5.png',
      'title': 'Show em Cena',
      'description': 'Tudo sobre o mundo dos espetáculos! Entrevistas com artistas, bastidores de grandes shows e dicas para aproveitar ao máximo cada experiência cultural.',
      'date': '09/09/2025',
    },
  ];

  List<Map<String, dynamic>> favoritePodcasts = [];
  List<Map<String, dynamic>> markedPodcasts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadMarked();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites(widget.userId);
    setState(() {
      favoritePodcasts = favorites;
    });
  }

  Future<void> _loadMarked() async {
    final marked = await _dbHelper.getMarked(widget.userId);
    setState(() {
      markedPodcasts = marked;
    });
  }

  Future<void> _toggleFavorite(Map<String, String> podcast) async {
    final isFavorite = favoritePodcasts.any((p) => p['title'] == podcast['title']);
    
    if (isFavorite) {
      await _dbHelper.removeFavorite(widget.userId, podcast['title']!);
    } else {
      await _dbHelper.insertFavorite(widget.userId, podcast);
    }
    
    await _loadFavorites();
  }

  Future<void> _toggleMarked(Map<String, String> podcast) async {
    final isMarked = markedPodcasts.any((p) => p['title'] == podcast['title']);
    
    if (isMarked) {
      await _dbHelper.removeMarked(widget.userId, podcast['title']!);
    } else {
      await _dbHelper.insertMarked(widget.userId, podcast);
      // Mostra tela de confirmação apenas quando marca, não quando desmarca
      _showConfirmationScreen(podcast);
    }
    
    await _loadMarked();
  }

  void _showConfirmationScreen(Map<String, String> podcast) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ConfirmationScreen(
          title: podcast['title']!,
          imagePath: podcast['imagePath']!,
          description: podcast['description']!,
          date: podcast['date']!,
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
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          FavoritesScreen(userId: widget.userId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      ),
    ).then((_) => _loadFavorites());
  }

  void _navigateToMarked() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          MarkedScreen(userId: widget.userId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      ),
    ).then((_) => _loadMarked());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podflix'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: Colors.white),
            onPressed: _navigateToFavorites,
          ),
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.white),
            onPressed: _navigateToMarked,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[50],
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: podcasts.length,
          itemBuilder: (context, index) {
            final podcast = podcasts[index];
            final isFavorite = favoritePodcasts.any((p) => p['title'] == podcast['title']);
            final isMarked = markedPodcasts.any((p) => p['title'] == podcast['title']);
            
            return PodcastItem(
              imagePath: podcast['imagePath']!,
              title: podcast['title']!,
              description: podcast['description']!,
              date: podcast['date']!,
              isFavorite: isFavorite,
              isMarked: isMarked,
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
                      title: podcast['title']!,
                      imagePath: podcast['imagePath']!,
                      description: podcast['description']!,
                      date: podcast['date']!,
                      onFavorite: () => _toggleFavorite(podcast),
                      onMark: () => _toggleMarked(podcast),
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
              onFavoritePressed: () => _toggleFavorite(podcast),
              onMarkPressed: () => _toggleMarked(podcast),
            );
          },
        ),
      ),
    );
  }
}