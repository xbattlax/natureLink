import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Models/user.dart';
import 'BlogArticle.dart';
import '../constantes.dart';
import '../Models/Comment.dart';

class BlogPreviewPage extends StatefulWidget {
  final BlogArticle article;

  BlogPreviewPage({required this.article});

  @override
  _BlogPreviewPageState createState() => _BlogPreviewPageState();
}

class _BlogPreviewPageState extends State<BlogPreviewPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];

  Future<List<Comment>> getComment() async {
    final response = await http.get(
      Uri.parse('$apiUrl/public/articles/${widget.article.id}/comment'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<Comment> comments = [];
      for (var comment in json.decode(response.body)) {
        comments.add(Comment.fromJson(comment));
      }
      return comments;
    } else {
      print('Failed to get comments');
      return [];
    }
  }

  Future<void> _postComment() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    String? userJson = await storage.read(key: 'user');

    if (userJson == null) {
      print('No jwt token');
      return;
    }
    User user = User.fromJson(json.decode(userJson));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$apiUrl/api/article/${widget.article.id}/comment'),
      headers: headers,
      body: json.encode({
        'content': _commentController.text,
        'author': user.pseudo,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      comments = await getComment();
      setState(() {
        _commentController.clear();
      });
    } else {
      print(response.body);
      print('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags
            Row(
              children: widget.article.tags.map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )).toList(),
            ),
            Text(
              widget.article.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.article.DateDePublication.day}/${widget.article.DateDePublication.month}/${widget.article.DateDePublication.year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.article.content,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Commentaires:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FutureBuilder<List<Comment>>(
              future: getComment(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Comment> comments = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comments.map((comment) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.author + ':',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(comment.content),
                          SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Failed to load comments: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            // Comments section
            // Replace with actual comments list widget
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _postComment,
                  icon: Icon(Icons.send),
                ),
              ),
              maxLines: null,
              minLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
