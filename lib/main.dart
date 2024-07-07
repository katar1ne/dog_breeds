import 'package:flutter/material.dart';

import 'dog_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageListScreen(),
    );
  }
}
