import 'dart:convert';

import 'package:chasse_marche_app/constantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../constantes.dart';


class BlogArticleForm extends StatefulWidget {
  @override
  _BlogArticleFormState createState() => _BlogArticleFormState();
}

class _BlogArticleFormState extends State<BlogArticleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  Future<void> _postArticle(String title, String content, List<String> tags) async {
    final url = '$apiUrl/api/article/post';

    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'title': title,
      'content': content,
      'tags': tags.join(','),
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 201) {
        // Show a success message, e.g., using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article créé avec succès')));
      } else {
        // Handle the error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la création de l\'article')));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la création de l\'article')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvel article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un contenu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (séparés par des virgules)',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final content = _contentController.text;
                    final tags = _tagsController.text.split(',').map((tag) => tag.trim()).toList();
                    await _postArticle(title, content, tags);
                    Navigator.pop(context);
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}