import 'package:flutter/material.dart';
import 'package:podflix/database_helper.dart';
import 'details_screen.dart';
import '../widgets/podcast_item.dart';

class MarkedScreen extends StatefulWidget {
  final int userId;
  
  MarkedScreen({required this.userId});
  
  @override
  _MarkedScreenState createState() => _MarkedScreenState();
}

class _MarkedScreenState extends State<MarkedScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _markedPodcasts = [];

  @override
  void initState() {
    super.initState();
    _loadMarked();
  }

  Future<void> _loadMarked() async {
    final marked = await _dbHelper.getMarked(widget.userId);
    setState(() {
      _markedPodcasts = marked;
    });
  }

  Future<void> _removeMarked(String title) async {
    await _dbHelper.removeMarked(widget.userId, title);
    await _loadMarked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcasts Marcados'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: Container(
        color: Colors.blue[50],
        child: _markedPodcasts.isEmpty
            ? Center(
                child: Text(
                  'Nenhum podcast marcado ainda!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _markedPodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = _markedPodcasts[index];

                  return PodcastItem(
                    imagePath: podcast['image_path'],
                    title: podcast['title'],
                    description: podcast['description'],
                    date: podcast['date'],
                    isMarked: true,
                    onDetailsPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
                            title: podcast['title'],
                            imagePath: podcast['image_path'],
                            description: podcast['description'],
                            date: podcast['date'],
                            onFavorite: () {},
                            onMark: () => _removeMarked(podcast['title']),
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
                    onMarkPressed: () => _removeMarked(podcast['title']),
                  );
                },
              ),
      ),
    );
  }
}