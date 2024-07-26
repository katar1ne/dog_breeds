import 'package:carousel_slider/carousel_slider.dart';
import 'package:dog_breeds/services/google_auth_service.dart';
import 'package:dog_breeds/widgets/comment_section.dart';
import 'package:dog_breeds/widgets/like_button.dart';
import 'package:flutter/material.dart';

class DogBreedDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final int likes;
  final List<String> additionalImages;

  DogBreedDetailScreen({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.likes,
    required this.additionalImages,
  });

  @override
  _DogBreedDetailScreenState createState() => _DogBreedDetailScreenState();
}

class _DogBreedDetailScreenState extends State<DogBreedDetailScreen> {
  int _currentIndex = 0;
  bool _isLoggedIn = GoogleAuthService.isUserLoggedIn;
  final GlobalKey<CommentsSectionState> _commentsKey =
      GlobalKey<CommentsSectionState>();

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
            _buildCarouselSlider(allImages),
            _buildIndicator(allImages.length),
            _buildDescription(widget.description),
            CommentsSection(imagePath: widget.imagePath, key: _commentsKey),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(List<String> allImages) {
    return CarouselSlider(
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
                if (_isLoggedIn)
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    child: LikeButton(
                        imagePath: imagePath, initialLikes: widget.likes),
                  ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
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
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _addComment() {
    _commentsKey.currentState?.showAddCommentDialog();
  }
}
