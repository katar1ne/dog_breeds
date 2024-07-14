class DogBreed {
  final String title;
  final String description;
  final String path;
  final List<String> additionalImages;

  DogBreed({
    required this.title,
    required this.description,
    required this.path,
    required this.additionalImages,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      title: json['title'],
      description: json['description'],
      path: json['path'],
      additionalImages: json['additional_images'] != null
          ? List<String>.from(json['additional_images'])
          : [],
    );
  }
}
