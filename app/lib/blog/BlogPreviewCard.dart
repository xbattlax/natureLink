import 'package:flutter/material.dart';
import 'BlogArticle.dart';
import 'BlogPreviewPage.dart';
import 'dart:math';

class BlogPreviewCard extends StatelessWidget {
  final BlogArticle article;

  const BlogPreviewCard({required this.article});

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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.DateDePublication.day}/${article.DateDePublication.month}/${article.DateDePublication.year}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.content.substring(0, min(100, article.content.length)) + '...',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: article.tags.map((tag) => TagWidget(tag: tag)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  final String tag;

  const TagWidget({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      margin: const EdgeInsets.only(right: 8),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
