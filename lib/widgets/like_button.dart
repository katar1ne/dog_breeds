import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeButton extends StatefulWidget {
  final String imagePath;

  LikeButton({required this.imagePath});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
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
    return IconButton(
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
    );
  }
}
