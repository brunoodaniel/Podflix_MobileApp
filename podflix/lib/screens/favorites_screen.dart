import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favoritePodcasts;

  FavoritesScreen({required this.favoritePodcasts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcasts Favoritos'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: Container(
        color: Colors.blue[50],
        child: favoritePodcasts.isEmpty
            ? Center(
                child: Text(
                  'Nenhum podcast favorito ainda!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: favoritePodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = favoritePodcasts[index];

                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeInOut,
                    )),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Image.asset(
                          podcast['imagePath'] ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(podcast['title'] ?? 'Título não disponível'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(podcast['description'] ?? 'Descrição não disponível'),
                            Text(
                              'Data: ${podcast['date']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void navigateToFavoritesScreen(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => FavoritesScreen(favoritePodcasts: []),
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
