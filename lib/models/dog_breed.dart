class DogBreed {
  final int id;
  final String path;
  final String title;
  final String description;
  final List<String> additionalImages;

  DogBreed({
    required this.id,
    required this.path,
    required this.title,
    required this.description,
    required this.additionalImages,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'],
      path: json['path'],
      title: json['title'],
      description: json['description'],
      additionalImages: List<String>.from(json['additional_images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'title': title,
      'description': description,
      'additional_images': additionalImages,
    };
  }
}
