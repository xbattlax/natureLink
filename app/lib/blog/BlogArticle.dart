class BlogArticle {
  int id;
  String title;
  DateTime DateDePublication;
  String content;
  String img;
  List<String> tags;

  BlogArticle({
    required this.id,
    required this.title,
    required this.DateDePublication,
    required this.content,
    required this.img,
    this.tags = const []
  });

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    return BlogArticle(
      id: json['id'],
      title: json['title'],
      DateDePublication: DateTime.parse(json['DateDePublication']["date"]),
      content: json['content'],
      img: json['img'],
      tags: List<String>.from(json['tags']),
    );
  }
}
