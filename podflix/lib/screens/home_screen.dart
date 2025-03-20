import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';
import 'marked_screen.dart';
import 'login_screen.dart';
import 'confirmation_screen.dart';
import '../widgets/podcast_item.dart';

class HomeScreen extends StatefulWidget {
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

  List<Map<String, String>> favoritePodcasts = [];
  List<Map<String, String>> markedPodcasts = [];

  void _navigateToMarkedScreen() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MarkedScreen(markedPodcasts: markedPodcasts),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      ),
    );
    setState(() {});
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
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => FavoritesScreen(favoritePodcasts: favoritePodcasts),
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
          ),
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.white),
            onPressed: _navigateToMarkedScreen,
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
            return PodcastItem(
              imagePath: podcasts[index]['imagePath']!,
              title: podcasts[index]['title']!,
              description: podcasts[index]['description']!,
              date: podcasts[index]['date']!,
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
                      title: podcasts[index]['title']!,
                      imagePath: podcasts[index]['imagePath']!,
                      description: podcasts[index]['description']!,
                      date: podcasts[index]['date']!,
                      onFavorite: () {
                        setState(() {
                          if (!favoritePodcasts.contains(podcasts[index])) {
                            favoritePodcasts.add(podcasts[index]);
                          }
                        });
                      },
                      onMark: () {
                        setState(() {
                          if (!markedPodcasts.contains(podcasts[index])) {
                            markedPodcasts.add(podcasts[index]);
                          }
                        });

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmationScreen(
                              title: podcasts[index]['title']!,
                              imagePath: podcasts[index]['imagePath']!,
                              description: podcasts[index]['description']!,
                              date: podcasts[index]['date']!,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ));
                              return FadeTransition(opacity: fadeAnimation, child: child);
                            },
                          ),
                        ).then((_) => setState(() {}));
                      },
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
            );
          },
        ),
      ),
    );
  }
}
