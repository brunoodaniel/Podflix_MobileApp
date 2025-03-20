import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String date;
  final VoidCallback onFavorite;
  final VoidCallback onMark;

  DetailsScreen({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.date,
    required this.onFavorite,
    required this.onMark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text(
              'Data: $date',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onFavorite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 172, 255),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Favoritar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: onMark,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Marcar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToDetailsScreen(BuildContext context) {
  // A função Navigator.push empurra uma nova tela para a pilha de navegação.
  // Estamos utilizando PageRouteBuilder para personalizar a transição entre as telas.
  Navigator.push(
    context,
    // PageRouteBuilder é usado para criar uma rota personalizada com animação.
    PageRouteBuilder(
      // O pageBuilder cria a tela para qual vamos navegar, passando os dados necessários.
      pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
        title: 'Podcast Title', // Título do podcast a ser mostrado na tela de detalhes
        imagePath: 'assets/podcast_image.png', // Caminho para a imagem do podcast
        description: 'This is the podcast description.', // Descrição do podcast
        date: '2025-03-20', // Data de lançamento ou outra informação relevante
        onFavorite: () {}, // Função de callback para adicionar aos favoritos
        onMark: () {}, // Função de callback para marcar o podcast
      ),
      // transitionsBuilder define a animação da transição entre as telas.
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Aqui, estamos criando uma animação de fade.
        // A animação de fade faz com que a tela "desapareça" de uma e "apareça" na outra.
        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animation, // Animação principal para a transição
          curve: Curves.easeInOut, // A curva que define como a animação se comporta (suaviza o efeito)
        ));
        
        // Returna o FadeTransition, que aplica a animação de opacidade na tela de destino (child).
        return FadeTransition(opacity: fadeAnimation, child: child);
      },
    ),
  );
}

