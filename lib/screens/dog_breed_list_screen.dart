import 'package:flutter/material.dart';

import '../models/dog_breed.dart';
import '../services/dog_breed_service.dart';
import 'dog_breed_detail_screen.dart';

class DogBreedListScreen extends StatefulWidget {
  @override
  _DogBreedListScreenState createState() => _DogBreedListScreenState();
}

class _DogBreedListScreenState extends State<DogBreedListScreen> {
  late Future<List<DogBreed>> futureDogBreeds;
  final DogBreedService dogBreedService = DogBreedService();

  @override
  void initState() {
    super.initState();
    futureDogBreeds = dogBreedService.fetchDogBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Breeds'),
      ),
      body: FutureBuilder<List<DogBreed>>(
        future: futureDogBreeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dogBreeds = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de colunas
                crossAxisSpacing:
                    4.0, // Espaçamento horizontal entre as colunas
                mainAxisSpacing: 4.0, // Espaçamento vertical entre as linhas
              ),
              itemCount: dogBreeds.length,
              itemBuilder: (context, index) {
                final dogBreed = dogBreeds[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DogBreedDetailScreen(
                          imagePath: dogBreed.path,
                          title: dogBreed.title,
                          description: dogBreed.description,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            dogBreed.path,
                            fit: BoxFit
                                .cover, // Ajusta a imagem para cobrir o espaço disponível
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dogBreed.title),
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
