import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DogBreedDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final List<String> additionalImages;

  DogBreedDetailScreen({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.additionalImages,
  });

  @override
  _DogBreedDetailScreenState createState() => _DogBreedDetailScreenState();
}

class _DogBreedDetailScreenState extends State<DogBreedDetailScreen> {
  int _currentIndex = 0;
  bool _isLiked = false;
  late String _likeKey;

  @override
  void initState() {
    super.initState();
    _likeKey = 'liked_${widget.imagePath}';
    _loadLikedState();
  }

  void _loadLikedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked = prefs.getBool(_likeKey) ?? false;
    });
  }

  void _saveLikedState(bool liked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_likeKey, liked);
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [widget.imagePath, ...widget.additionalImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 1.0,
                aspectRatio: 2.0,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: allImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Positioned(
                          bottom: 8.0,
                          left: 8.0,
                          child: IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                                _saveLikedState(_isLiked);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allImages.length,
                (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
