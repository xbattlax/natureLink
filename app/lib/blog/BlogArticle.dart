class BlogArticle {
  String title;
  DateTime publicationDate;
  String content;
  List<String> tags;

  BlogArticle({required this.title, required this.publicationDate, required this.content, this.tags = const []});

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    json['tags'] = json['tags'] ?? [];
    return BlogArticle(
      title: json['title'],
      publicationDate: DateTime.parse(json['publicationDate']),
      content: json['content'],
      tags: List<String>.from(json['tags']),
    );
  }
}