

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/Comment.dart';
import 'package:http/http.dart' as http;

import '../constantes.dart';

class CommentsSection extends StatefulWidget {
  final List<Comment> comments;
  final int articleId;

  CommentsSection({required this.comments, required this.articleId});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/article/${widget.articleId}/comment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'content': _commentController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        widget.comments.add(Comment.fromJson(json.decode(response.body)));
      });
      _commentController.clear();
    } else {
      print('Failed to add comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments:'),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.comments[index].author),
              subtitle: Text(widget.comments[index].content),
            );
          },
        ),
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(labelText: 'Add a comment'),
        ),
        ElevatedButton(
          onPressed: _addComment,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
