import 'package:flutter/material.dart';

import 'screens/dog_breed_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breeds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DogBreedListScreen(),
    );
  }
}
