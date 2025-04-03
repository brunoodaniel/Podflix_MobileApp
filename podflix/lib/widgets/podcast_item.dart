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
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onDetailsPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do podcast com cache
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Falha ao carregar imagem',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Informações do podcast
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Publicador
                  const SizedBox(height: 4),
                  Text(
                    publisher,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Descrição
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Data e ações
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Data de publicação
                      Flexible(
                        child: Text(
                          'Publicado em: $date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Ações (favoritar/marcar)
                      if (showActions) ...[
                        Row(
                          children: [
                            // Botão de favorito
                            if (onFavoritePressed != null)
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey[600],
                                ),
                                onPressed: onFavoritePressed,
                                splashRadius: 20,
                                tooltip: isFavorite
                                    ? 'Remover dos favoritos'
                                    : 'Adicionar aos favoritos',
                              ),

                            // Botão de marcação
                            if (onMarkPressed != null)
                              IconButton(
                                icon: Icon(
                                  isMarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isMarked ? Colors.blue : Colors.grey[600],
                                ),
                                onPressed: onMarkPressed,
                                splashRadius: 20,
                                tooltip: isMarked
                                    ? 'Remover da lista'
                                    : 'Marcar para ouvir depois',
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}