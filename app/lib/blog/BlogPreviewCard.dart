import 'package:flutter/material.dart';
import 'BlogArticle.dart';
import 'BlogPreviewPage.dart';
import 'dart:math';

class BlogPreviewCard extends StatelessWidget {
  final BlogArticle article;

  BlogPreviewCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPreviewPage(article: article),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${article.publicationDate.day}/${article.publicationDate.month}/${article.publicationDate.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  article.content.substring(0, min(100, article.content.length)) + '...',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}





