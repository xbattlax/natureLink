import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/BottomNav.dart';
import 'BlogArticle.dart';
import 'BlogPreviewPage.dart';
import 'package:http/http.dart' as http;
import 'BlogPreviewCard.dart';
import 'BlogArticleForm.dart';
import '../LoginPage.dart';


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
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return BlogPreviewCard(article: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _redirectToLoginPage(context));
            return Center(child: Text("Redirecting to login page..."));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogArticleForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

void _redirectToLoginPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}

Future<List<BlogArticle>> fetchArticles() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  if (token == null) {
    print('No access token found');
    throw Exception('Failed to fetch articles'); // Return an empty list instead of null
  }

  final response = await http.get(
    Uri.parse('http://localhost:8000/api/articles'),
    headers: {
      'Authorization': 'Bearer $token',
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Successfully fetched articles
    String responseBody = response.body;
    List<dynamic> parsedJson = json.decode(responseBody); // Directly decode the response body into a List<dynamic>

    List<BlogArticle> articles = parsedJson.map((item) => BlogArticle.fromJson(item)).toList();
    return articles;
  } else {
    // Handle error or show an error message
    print('Failed to fetch articles');
    throw Exception('Failed to fetch articles'); // Return an empty list instead of null
  }
}





/*Future<List<BlogArticle>> fetchBlogArticles() async {
  final response = await http.get(Uri.parse('https://your-api-url.com/articles'));
  var jsonTest = """[
  {
    "title": "Mon premier article",
  "publicationDate": "2022-03-07T09:30:00.000Z",
  "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ac nulla vitae odio porttitor tristique. Proin dictum, leo a semper sodales, sapien odio pharetra sapien, eget bibendum magna nibh at urna. Duis interdum, urna a aliquet porttitor, felis turpis euismod velit, eu fringilla ex augue non ipsum. Sed finibus metus enim, eu luctus augue gravida eu. Sed sit amet nibh vitae mauris malesuada luctus a a velit. Nam vel hendrerit magna, eu rutrum neque. Vestibulum condimentum aliquet risus, eu vestibulum ex ultrices vitae. Aliquam bibendum lobortis tortor eu rutrum. Sed et risus ligula. Aenean at ante turpis. ",
  "tags": [
    "Officiel",
    "tag2",
    "tag3"
  ]
  },
  {
  "title": "Mon deuxième article",
  "publicationDate": "2022-03-08T14:45:00.000Z",
  "content": "Sed laoreet purus eget leo dapibus, nec faucibus sem vestibulum. Suspendisse interdum sapien vel velit elementum, in tincidunt nisi fermentum. Vestibulum pulvinar nulla mauris, vitae consectetur ipsum euismod id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer congue metus non erat elementum, a malesuada mi suscipit. Curabitur tristique vel justo in consequat. Sed eget neque nisi. In quis ante eget urna placerat venenatis eu vel arcu. Donec varius risus at fermentum tincidunt. "
  },
  {
  "title": "Mon troisième article",
  "publicationDate": "2022-03-09T11:15:00.000Z",
  "content": "Aenean placerat ut felis id aliquam. Ut tincidunt ipsum eu velit finibus, a luctus est euismod. Praesent eget massa sapien. Integer rhoncus nunc vel sapien aliquet tempus. Vivamus quis tincidunt enim. Maecenas sollicitudin urna ac justo scelerisque interdum. Cras consequat ligula in augue placerat, vel varius ipsum efficitur. Nulla dictum, dolor eget blandit vehicula, lectus orci laoreet lorem, vel luctus augue orci eget arcu. Aenean vel convallis nibh. Vestibulum laoreet, nulla sed blandit sagittis, augue ex blandit mauris, a lacinia libero urna vitae nisi. "
  }
  ]""";
  List<dynamic> articlesJson = jsonDecode(jsonTest);
  List<BlogArticle> articles = articlesJson.map((jsonTest) => BlogArticle.fromJson(jsonTest)).toList();

  //if (response.statusCode == 200) {
    //List<dynamic> articlesJson = jsonDecode(response.body);
    //List<BlogArticle> articles = articlesJson.map((json) => BlogArticle.fromJson(json)).toList();
    //return articles;
  //} else {
    //throw Exception('Failed to load articles');
  //}
  return articles;
}*/