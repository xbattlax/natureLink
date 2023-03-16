import 'package:flutter/material.dart';
import 'BlogArticle.dart';

class BlogPreviewPage extends StatelessWidget {
  final BlogArticle article;

  BlogPreviewPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //tags

              Row(
                children: article.tags.map((tag) => Container(
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
              article.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${article.publicationDate.day}/${article.publicationDate.month}/${article.publicationDate.year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              article.content,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}