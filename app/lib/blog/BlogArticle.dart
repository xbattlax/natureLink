class BlogArticle {
  String titre;
  String Auteur;
  DateTime DateDePublication;
  String Contenu;
  List<String> likes;
  int likeCount;
  bool isLiked;
  List<String> tags;
  String imageUrl; // new field for the image URL or file path

  BlogArticle({required this.titre, required this.likes,required this.likeCount,required this.isLiked,required this.Auteur, required this.DateDePublication, required this.Contenu, required this.imageUrl, this.tags = const []});

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    json['tags'] = json['tags'] ?? [];
    return BlogArticle(
      titre: json['titre'],
      Auteur: json['Auteur'],
      DateDePublication: DateTime.parse(json['DateDePublication']),
      Contenu: json['Contenu'],
      imageUrl: json['imageUrl'],
      isLiked: json['isLiked'],
      likes: json['likes'],
      likeCount: json['likeCount'],
      tags: List<String>.from(json['tags']),
    );
  }
}