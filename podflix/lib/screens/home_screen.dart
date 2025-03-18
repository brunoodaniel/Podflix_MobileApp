import 'package:flutter/material.dart';
import 'package:podflix/screens/favorites_screen.dart';  // Tela de Favoritos
import 'package:podflix/screens/marked_screen.dart';  // Tela de Podcasts Marcados
import 'details_screen.dart'; 
import '../widgets/podcast_item.dart';
import 'login_screen.dart';  
import 'confirmation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> podcasts = [
    {
      'imagePath': 'assets/podcast1.png',
      'title': 'Podcast 1',
      'description': 'Uma discussão interessante sobre tecnologia.',
    },
    {
      'imagePath': 'assets/podcast2.png',
      'title': 'Podcast 2',
      'description': 'Explorando o mundo dos games.',
    },
    {
      'imagePath': 'assets/podcast3.png',
      'title': 'Podcast 3',
      'description': 'Os melhores filmes do ano analisados.',
    },
    {
      'imagePath': 'assets/podcast4.png',
      'title': 'Podcast 4',
      'description': 'Histórias inspiradoras de sucesso.',
    },
    {
      'imagePath': 'assets/podcast5.png',
      'title': 'Podcast 5',
      'description': 'Dicas de produtividade para o dia a dia.',
    },
  ];

  List<Map<String, String>> favoritePodcasts = [];
  List<Map<String, String>> markedPodcasts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podflix'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen(favoritePodcasts: favoritePodcasts)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkedScreen(markedPodcasts: markedPodcasts)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          return PodcastItem(
            imagePath: podcasts[index]['imagePath']!,
            title: podcasts[index]['title']!,
            description: podcasts[index]['description']!,
            onDetailsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    title: podcasts[index]['title']!,
                    imagePath: podcasts[index]['imagePath']!,
                    description: podcasts[index]['description']!,
                    onFavorite: () {
                      setState(() {
                        favoritePodcasts.add(podcasts[index]);
                      });
                    },
                    onMark: () {
                      setState(() {
                        markedPodcasts.add(podcasts[index]);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationScreen(
                            title: podcasts[index]['title']!,
                            imagePath: podcasts[index]['imagePath']!,
                            description: podcasts[index]['description']!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
