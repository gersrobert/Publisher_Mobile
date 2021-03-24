import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:publisher/DTO/DetailedArticle.dart';
import 'package:publisher/customWidgets/pAppBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailedArticlePage extends StatefulWidget {
  final String id;

  DetailedArticlePage({Key key, @required this.id}) : super(key: key);
  @override
  _DetailedArticlePageState createState() => _DetailedArticlePageState();
}

class _DetailedArticlePageState extends State<DetailedArticlePage> {
  DetailedArticle _article;
  bool _error;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;
    getDetailedArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: getBody(),
    );
  }

  void getDetailedArticle() async {
    try {
      final response = await http.get(
          Uri.http('${env['HOST']}:${env['PORT']}', 'article/${widget.id}'));

      if (response.statusCode != 200) {
        throw Exception('Invalid response code');
      }

      setState(() {
        _loading = false;
        _article = DetailedArticle.fromJson(jsonDecode(response.body));
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Widget getBody() {
    if (_article == null) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              getDetailedArticle();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading article, tap to try again"),
          ),
        ));
      }
    } else {
      return Text('${_article.title}');
    }
    return Container();
  }
}
