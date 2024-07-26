import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/dog_breed.dart';

class DogBreedService {
  Future<List<DogBreed>> fetchDogBreeds(
      {required int startIndex, required int limit}) async {
    final String response =
        await rootBundle.loadString('assets/dog_breeds.json');
    final List<dynamic> data = json.decode(response);
    final List<DogBreed> allBreeds =
        data.map((json) => DogBreed.fromJson(json)).toList();

    return allBreeds.skip(startIndex).take(limit).toList();
  }
}
