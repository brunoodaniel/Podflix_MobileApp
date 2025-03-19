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
      'title': 'Podcast 1aaaaaaaaaaaaaaaaaaaaaaaaaa',
      'description': 'Uma discussão interessante sobre tecnologia.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      'date': '15/10/2023',
    },
    {
      'imagePath': 'assets/podcast2.png',
      'title': 'Podcast 2',
      'description': 'Explorando o mundo dos games.',
      'date': '15/10/2023',
    },
    {
      'imagePath': 'assets/podcast3.png',
      'title': 'Podcast 3',
      'description': 'Os melhores filmes do ano analisados.',
      'date': '15/10/2023',
    },
    {
      'imagePath': 'assets/podcast4.png',
      'title': 'Podcast 4',
      'description': 'Histórias inspiradoras de sucesso.',
      'date': '15/10/2023',
    },
    {
      'imagePath': 'assets/podcast5.png',
      'title': 'Podcast 5',
      'description': 'Dicas de produtividade para o dia a dia.',
      'date': '15/10/2023',
    },
  ];

  List<Map<String, String>> favoritePodcasts = [];
  List<Map<String, String>> markedPodcasts = [];

  void _navigateToMarkedScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkedScreen(markedPodcasts: markedPodcasts),
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
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoritePodcasts: favoritePodcasts),
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
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
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
                          MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(
                              title: podcasts[index]['title']!,
                              imagePath: podcasts[index]['imagePath']!,
                              description: podcasts[index]['description']!,
                              date: podcasts[index]['date']!,
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
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
