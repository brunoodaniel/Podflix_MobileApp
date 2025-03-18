import 'package:flutter/material.dart';

class MarkedScreen extends StatelessWidget {
  final List<Map<String, String>> markedPodcasts;

  MarkedScreen({required this.markedPodcasts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcasts Marcados'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: markedPodcasts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Image.asset(
                markedPodcasts[index]['imagePath']!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(markedPodcasts[index]['title']!),
              subtitle: Text(markedPodcasts[index]['description']!),
            ),
          );
        },
      ),
    );
  }
}
