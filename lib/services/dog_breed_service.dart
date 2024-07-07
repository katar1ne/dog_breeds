import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/dog_breed.dart';

class DogBreedService {
  Future<List<DogBreed>> fetchDogBreeds() async {
    final response = await rootBundle.loadString('assets/dog-breeds.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => DogBreed.fromJson(json)).toList();
  }
}
