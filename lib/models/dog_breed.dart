class DogBreed {
  final String path;
  final String title;
  final String description;

  DogBreed(
      {required this.path, required this.title, required this.description});

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      path: json['path'],
      title: json['title'],
      description: json['description'],
    );
  }
}
