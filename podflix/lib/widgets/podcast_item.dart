import 'package:flutter/material.dart';

class PodcastItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String date;
  final bool isFavorite;
  final bool isMarked;
  final VoidCallback onDetailsPressed;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onMarkPressed;

  PodcastItem({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.date,
    this.isFavorite = false,
    this.isMarked = false,
    required this.onDetailsPressed,
    this.onFavoritePressed,
    this.onMarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imagePath, 
                  height: 150, 
                  width: double.infinity, 
                  fit: BoxFit.cover
                ),
              ),
              if (isFavorite || isMarked)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      if (isFavorite)
                        Icon(Icons.star, color: Colors.amber, size: 30),
                      if (isMarked)
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  'Data: $date',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (onFavoritePressed != null)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : Colors.grey,
                          size: 30,
                        ),
                        onPressed: onFavoritePressed,
                      ),
                    if (onMarkPressed != null)
                      IconButton(
                        icon: Icon(
                          isMarked ? Icons.check_circle : Icons.check_circle_outline,
                          color: isMarked ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                        onPressed: onMarkPressed,
                      ),
                    ElevatedButton(
                      onPressed: onDetailsPressed,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, 
                        backgroundColor: Colors.blue[100],
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Mais Detalhes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}