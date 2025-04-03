import 'package:flutter/material.dart';
import 'package:podflix/services/database_helper.dart';
import 'package:podflix/widgets/podcast_item.dart';

class MarkedScreen extends StatefulWidget {
  final int userId;
  
  const MarkedScreen({Key? key, required this.userId}) : super(key: key);
  
  @override
  _MarkedScreenState createState() => _MarkedScreenState();
}

class _MarkedScreenState extends State<MarkedScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _markedPodcasts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMarked();
  }

  Future<void> _loadMarked() async {
    setState(() => _isLoading = true);
    try {
      final marked = await _dbHelper.getMarked(widget.userId);
      setState(() => _markedPodcasts = marked);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar marcados: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeMarked(String title) async {
    try {
      await _dbHelper.removeMarked(widget.userId, title);
      await _loadMarked();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removido dos marcados')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover marcado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistir Mais Tarde'),
        backgroundColor: const Color.fromARGB(255, 100, 172, 255),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _markedPodcasts.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum podcast marcado ainda!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMarked,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _markedPodcasts.length,
                    itemBuilder: (context, index) {
                      final podcast = _markedPodcasts[index];
                      return PodcastItem(
                        imageUrl: podcast['image_path'],
                        title: podcast['title'],
                        description: podcast['description'],
                        publisher: podcast['publisher'] ?? 'Desconhecido',
                        date: podcast['date'],
                        isMarked: true,
                        onMarkPressed: () => _removeMarked(podcast['title']),
                      );
                    },
                  ),
                ),
    );
  }
}