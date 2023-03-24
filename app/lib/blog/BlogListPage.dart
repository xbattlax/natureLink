import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'BlogArticle.dart';
import 'BlogPreviewPage.dart';
import 'package:http/http.dart' as http;
import 'BlogPreviewCard.dart';
import 'BlogArticleForm.dart';

class BlogListPage extends StatelessWidget {
  final Function onError;
  BlogListPage({required this.onError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: FutureBuilder<List<BlogArticle>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return BlogPreviewCard(article: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            //WidgetsBinding.instance.addPostFrameCallback((_) => _redirectToLoginPage(context));
            return Center(child: Text("Redirecting to login page..."));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FutureBuilder<String>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != '') {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogArticleForm(),
                  ),
                );
              },
              child: Icon(Icons.add),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

Future<String> getToken() async {
  FlutterSecureStorage().read(key: 'jwt_token').then((value) {
    print(value);
    return value;
  });
  return '';
}

Future<List<BlogArticle>> fetchArticles() async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/public/articles'),
    headers: {
      'accept': 'application/json',
    },
  );
  print(response.body) ;
  if (response.statusCode == 200) {
    // Successfully fetched articles
    String responseBody = response.body;
    List<dynamic> parsedJson = json.decode(responseBody); // Directly decode the response body into a List<dynamic>

    List<BlogArticle> articles = parsedJson.map((item) => BlogArticle.fromJson(item)).toList();
    print(articles);
    return articles;
  } else {
    // Handle error or show an error message
    print('Failed to fetch articles');
    throw Exception('Failed to fetch articles'); // Return an empty list instead of null
  }
}
