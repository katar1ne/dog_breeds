import 'package:dog_breeds/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeButton extends StatefulWidget {
  final String imagePath;
  final int initialLikes;

  LikeButton({required this.imagePath, required this.initialLikes});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  late String _likeKey;
  bool _isLoggedIn = GoogleAuthService.isUserLoggedIn;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likeKey = 'liked_${widget.imagePath}';
    _likes = widget.initialLikes;
    _loadLikedState();
  }

  void _loadLikedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked = prefs.getBool(_likeKey) ?? false;
      if (_isLiked) {
        _likes += 1;
      }
    });
  }

  void _saveLikedState(bool liked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_likeKey, liked);
    setState(() {
      _likes += liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Container();
    }

    return Row(
      children: [
        IconButton(
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
        Text('$_likes'),
      ],
    );
  }
}
