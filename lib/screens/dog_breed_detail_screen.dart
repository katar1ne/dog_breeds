import 'package:carousel_slider/carousel_slider.dart';
import 'package:dog_breeds/services/google_auth_service.dart';
import 'package:dog_breeds/widgets/like_button.dart';
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
  bool _isLoggedIn = GoogleAuthService.isUserLoggedIn;
  List<String> _comments = [];
  late String _commentsKey;

  @override
  void initState() {
    super.initState();
    _commentsKey = 'comments_${widget.imagePath}';
    _loadComments();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isLoggedIn = GoogleAuthService.isUserLoggedIn;
    });
  }

  void _loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _comments = prefs.getStringList(_commentsKey) ?? [];
    });
  }

  void _saveComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_commentsKey, _comments);
  }

  void _addComment() async {
    if (!_isLoggedIn) {
      // Mostra um alerta se o usuário não estiver logado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você precisa estar logado para comentar.')),
      );
      return;
    }

    final commentController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Comentário'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'Digite seu comentário'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(commentController.text);
              },
              child: Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _comments.add(result);
        _saveComments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [widget.imagePath, ...widget.additionalImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: _addComment,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCarouselSlider(allImages),
            _buildIndicator(allImages.length),
            _buildDescription(widget.description),
            if (_comments.isNotEmpty) _buildCommentsSection(),
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
                    child: LikeButton(imagePath: imagePath),
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

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentários',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ..._comments.map((comment) => ListTile(
                leading: Icon(Icons.person),
                title: Text(comment),
              )),
        ],
      ),
    );
  }
}
