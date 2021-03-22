import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/customWidgets/pAppBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageNumber = 0;
  Future<List<Article>> _articles;

  List<Article> parseArticles(String responseBody) {
    Map<String, dynamic> parsed = jsonDecode(responseBody);

    return parsed['content']
        .map<Article>((json) => Article.fromJson(json))
        .toList();
  }

  Future<List<Article>> getArticles() async {
    var queryParameters = {"page": "${this._currentPageNumber}"};

    final response =
        await http.get(Uri.http('localhost:10420', 'article', queryParameters));
    if (response.statusCode == 200) {
      return parseArticles(response.body);
    } else {
      throw Exception('Invalid response code');
    }
  }

  @override
  void initState() {
    super.initState();
    _articles = getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PAppBar(),
        body: FutureBuilder(
          future: _articles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Article article = snapshot.data[index];
                    return Column(
                      children: [
                        Text('${article.title}'),
                      ],
                    );
                  },
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomSheet: Row(
          children: [
            RawMaterialButton(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20.0,
              ),
              shape: CircleBorder(),
              fillColor: Colors.pink,
              elevation: 2.0,
              onPressed: () {
                if (this._currentPageNumber > 0) {
                  this._currentPageNumber -= 1;
                  setState(() {
                    _articles = getArticles();
                  });
                }
              },
            ),
            Text('${_currentPageNumber + 1}'),
            RawMaterialButton(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.0,
              ),
              shape: CircleBorder(),
              fillColor: Colors.pink,
              elevation: 2.0,
              onPressed: () {
                if (this._currentPageNumber >= 0) {
                  this._currentPageNumber += 1;
                  setState(() {
                    _articles = getArticles();
                  });
                }
              },
            ),
          ],
        )

        // ElevatedButton(
        //   onPressed: () {
        //     this._currentPageNumber += 1;
        //     setState(() {
        //       _articles = getArticles();
        //     });
        //   },
        //   child: Text('articles'),
        // ),
        );
  }
}
