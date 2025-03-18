import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final VoidCallback onFavorite;
  final VoidCallback onMark;

  DetailsScreen({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.onFavorite,
    required this.onMark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onFavorite,
                  child: Text('Favoritar'),
                ),
                ElevatedButton(
                  onPressed: onMark,
                  child: Text('Marcar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
