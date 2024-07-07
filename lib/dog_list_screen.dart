import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dog_detail_screen.dart';

class ImageItem {
  final String path;
  final String title;
  final String description;

  ImageItem(
      {required this.path, required this.title, required this.description});

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      path: json['path'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  late Future<List<ImageItem>> futureImages;

  Future<List<ImageItem>> fetchImages() async {
    final response = await rootBundle.loadString('assets/dog-breeds.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => ImageItem.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    futureImages = fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: FutureBuilder<List<ImageItem>>(
        future: futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final images = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de colunas
                crossAxisSpacing:
                    4.0, // Espaçamento horizontal entre as colunas
                mainAxisSpacing: 4.0, // Espaçamento vertical entre as linhas
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                          imagePath: image.path,
                          title: image.title,
                          description: image.description,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            image.path,
                            fit: BoxFit
                                .cover, // Ajusta a imagem para cobrir o espaço disponível
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(image.title),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
