import '../Models/Comment.dart';

class BlogArticle {
  int id;
  String title;
  DateTime DateDePublication;
  String content;
  String img;
  List<String> tags;
  final List<Comment> comments;

  BlogArticle({
    required this.id,
    required this.title,
    required this.DateDePublication,
    required this.content,
    required this.img,
    this.tags = const [],
    required this.comments,
  });

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    List<dynamic> commentsJson = json['comments'];
    List<Comment> comments = commentsJson.map((commentJson) => Comment.fromJson(commentJson)).toList();
    return BlogArticle(
      id: json['id'],
      title: json['title'],
      DateDePublication: DateTime.parse(json['DateDePublication']["date"]),
      content: json['content'],
      img: json['img'],
      tags: List<String>.from(json['tags']),
      comments: comments,

    );
  }
}
