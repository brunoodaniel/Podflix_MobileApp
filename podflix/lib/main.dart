import 'package:flutter/material.dart';

void main() {
  runApp(PodflixApp());
}

class PodflixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podflix',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Cadastrar-se'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podflix'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PodcastItem(
              imageUrl: 'https://source.unsplash.com/200x200/?podcast',
              title: 'Podcast de Exemplo: Como iniciar no mundo dos podcasts!',
            ),
            PodcastItem(
              imageUrl: 'https://source.unsplash.com/200x200/?radio',
              title: 'A história do rádio e sua evolução',
            ),
            PodcastItem(
              imageUrl: 'https://source.unsplash.com/200x200/?music',
              title: 'Música e Podcasts: Uma combinação perfeita',
            ),
          ],
        ),
      ),
    );
  }
}

class PodcastItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  PodcastItem({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
      ],
    );
  }
}
