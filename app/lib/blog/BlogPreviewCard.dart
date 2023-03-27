import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'BlogArticle.dart';
import 'BlogPreviewPage.dart';
import 'dart:math';

class BlogPreviewCard extends StatelessWidget {
  final BlogArticle article;

  BlogPreviewCard({required this.article});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogPreviewPage(article: article),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(article.content),
              SizedBox(height: 8),
              Wrap(
                children: article.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),

            ],
          ),
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
