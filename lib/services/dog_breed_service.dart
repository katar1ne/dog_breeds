import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/dog_breed.dart';

class DogBreedService {
  Future<List<DogBreed>> fetchDogBreeds(
      {int startIndex = 0, int limit = 6}) async {
    final response = await rootBundle.loadString('assets/dog-breeds.json');
    final List<dynamic> data = json.decode(response);
    return data
        .skip(startIndex)
        .take(limit)
        .map((json) => DogBreed.fromJson(json))
        .toList();
  }
}
