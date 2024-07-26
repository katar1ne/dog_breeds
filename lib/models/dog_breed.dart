class DogBreed {
  final String title;
  final String description;
  final String path;
  final int likes;
  final List<String> additionalImages;

  DogBreed({
    required this.title,
    required this.description,
    required this.path,
    required this.likes,
    required this.additionalImages,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      title: json['title'],
      description: json['description'],
      path: json['path'],
      likes: json['likes'],
      additionalImages: List<String>.from(json['additional_images']),
    );
  }
}
