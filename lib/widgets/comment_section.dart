import 'package:dog_breeds/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsSection extends StatefulWidget {
  final String imagePath;
  final GlobalKey<CommentsSectionState> key;

  CommentsSection({required this.imagePath, required this.key})
      : super(key: key);

  @override
  CommentsSectionState createState() => CommentsSectionState();
}

class CommentsSectionState extends State<CommentsSection> {
  List<Map<String, String>> _comments = [];
  late String _commentsKey;
  bool _isLoggedIn = GoogleAuthService.isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    _commentsKey = 'comments_${widget.imagePath}';
    _loadComments();
  }

  void _loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _comments = (prefs.getStringList(_commentsKey) ?? [])
          .map((comment) {
            try {
              final parts = comment.split('|');
              if (parts.length == 2) {
                return {
                  'email': parts[0].split(':')[1],
                  'comment': parts[1].split(':')[1],
                };
              } else {
                return <String,
                    String>{}; // Retorna um mapa vazio com tipos String
              }
            } catch (e) {
              // Se houver um erro ao processar o comentário, retorne um comentário vazio
              return <String, String>{};
            }
          })
          .where((comment) => comment.isNotEmpty)
          .toList() as List<Map<String, String>>;
    });
  }

  void _saveComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _commentsKey,
      _comments
          .map((comment) =>
              'email:${comment['email']}|comment:${comment['comment']}')
          .toList(),
    );
  }

  void addComment(String comment) {
    final userEmail = GoogleAuthService.currentUser?.email ?? 'Anônimo';
    if (_isLoggedIn) {
      setState(() {
        _comments.add({'email': userEmail, 'comment': comment});
        _saveComments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_comments.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Comentários',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._comments.map((comment) => ListTile(
                leading: Icon(Icons.person),
                title: Text(comment['email'] ?? 'Anônimo'),
                subtitle: Text(comment['comment'] ?? ''),
              )),
        ],
        if (_isLoggedIn)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:
                  showAddCommentDialog, // Tornar público para chamar de fora
              child: Text('Adicionar Comentário'),
            ),
          ),
      ],
    );
  }

  void showAddCommentDialog() async {
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
      addComment(result);
    }
  }
}
