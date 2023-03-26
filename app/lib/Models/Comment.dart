class Comment {
  final int id;
  final String author;
  final String content;

  Comment({required this.id, required this.author, required this.content});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      content: json['content'],
    );
  }
}