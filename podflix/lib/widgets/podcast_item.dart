import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PodcastItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String publisher;
  final String date;
  final VoidCallback? onDetailsPressed;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onMarkPressed;
  final bool isFavorite;
  final bool isMarked;
  final bool showActions;

  const PodcastItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.publisher,
    required this.date,
    this.onDetailsPressed,
    this.onFavoritePressed,
    this.onMarkPressed,
    this.isFavorite = false,
    this.isMarked = false,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onDetailsPressed,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagem do podcast (60% do card)
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 30, color: Colors.grey),
                          Text('Imagem não carregada', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Informações do podcast (40% do card)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Publicador e data
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              publisher,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      // Ações
                      if (showActions) Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Botão de favorito
                          if (onFavoritePressed != null)
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 24,
                                color: isFavorite ? Colors.red : Colors.grey[600],
                              ),
                              onPressed: onFavoritePressed,
                              splashRadius: 20,
                            ),

                          // Botão de marcação
                          if (onMarkPressed != null)
                            IconButton(
                              icon: Icon(
                                isMarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 24,
                                color: isMarked ? Colors.blue : Colors.grey[600],
                              ),
                              onPressed: onMarkPressed,
                              splashRadius: 20,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}