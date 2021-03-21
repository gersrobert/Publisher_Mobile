import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/customWidgets/pAppBar.dart';

class Home extends StatelessWidget {
  List<Article> parseArticles(String responseBody) {
    Map<String, dynamic> parsed = jsonDecode(responseBody);

    return parsed['content']
        .map<Article>((json) => Article.fromJson(json))
        .toList();
  }

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.http('localhost:10420', 'article'));

    if (response.statusCode == 200) {
      return parseArticles(response.body);
    } else {
      throw Exception('Invalid response code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              Article article = projectSnap.data[index];
              return Column(
                children: [
                  Text('${article.title}'),
                ],
              );
            },
          );
        },
        future: getArticles(),
      ),
      bottomSheet: ElevatedButton(
        onPressed: getArticles,
        child: Text('articles'),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: PAppBar(),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[],
  //       ),
  //     ),
  //     bottomSheet: ElevatedButton(
  //   );
  // }
}
