import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/dog_breed.dart';

class DogBreedService {
  Future<List<DogBreed>> fetchDogBreeds(
      {required int startIndex, required int limit}) async {
    // Simulando a busca de um arquivo JSON local
    final String response =
        await rootBundle.loadString('assets/dog_breeds.json');
    final List<dynamic> data = json.decode(response);
    final List<DogBreed> allBreeds =
        data.map((json) => DogBreed.fromJson(json)).toList();

    // Retornando uma sublista com base no índice de início e no limite
    return allBreeds.skip(startIndex).take(limit).toList();
  }
}
