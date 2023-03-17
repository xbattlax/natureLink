class BlogArticle {
  String titre;
  String Auteur;
  DateTime DateDePublication;
  String Contenu;
  List<String> tags;
  String imageUrl; // new field for the image URL or file path

  BlogArticle({required this.titre, required this.Auteur, required this.DateDePublication, required this.Contenu, required this.imageUrl, this.tags = const []});

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    json['tags'] = json['tags'] ?? [];
    return BlogArticle(
      titre: json['titre'],
      Auteur: json['Auteur'],
      DateDePublication: DateTime.parse(json['DateDePublication']),
      Contenu: json['Contenu'],
      imageUrl: json['imageUrl'],// new field
      tags: List<String>.from(json['tags']),
    );
  }
}