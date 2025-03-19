import 'package:flutter/material.dart';

class MarkedScreen extends StatelessWidget {
  final List<Map<String, String>> markedPodcasts;

  MarkedScreen({required this.markedPodcasts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcasts Marcados'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: Container(
        color: Colors.blue[50],
        child: markedPodcasts.isEmpty
            ? Center(
                child: Text(
                  'Nenhum podcast marcado ainda!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: markedPodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = markedPodcasts[index];

                  return Card(
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
                  );
                },
              ),
      ),
    );
  }
}
