import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:publisher/DTO/Article.dart';
import 'package:publisher/DTO/ArticleInsert.dart';
import 'package:publisher/DTO/Articles.dart';
import 'package:publisher/api/api.dart';
import 'package:publisher/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineSync {

  void initialize() async {
    Timer.periodic(Duration(seconds: 10), (t) => _syncArticleInsert());
  }

  void _syncArticleInsert() async {
    if (!Auth().getLoginStatus()) {
      return;
    }

    try {
      await Api().getAuthenticatedUser();
    } on SocketException {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var articles = prefs.getStringList('article_insert');

    for (var a in articles ?? []) {
      ArticleInsert article = ArticleInsert.fromJson(json.decode(a));
      if (article.id == null) {
        Api().addArticle(article.title, article.content, article.categories).then((value) => {});
      } else {
        Api().updateArticle(article.id, article.title, article.content, article.categories).then((value) => {});
      }
    }

    prefs.setStringList('article_insert', []);
  }

  void saveArticles(Articles articles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String key in prefs.getKeys()) {
      prefs.remove(key);
    }

    print('save articles');
    prefs.setString('articles', json.encode(articles));

    var response;
    for (Article article in articles.content) {
      response = await Api().getDetailedArticle(article.id);
      String encodedArticle = Utf8Decoder().convert(response.body.codeUnits);
      prefs.setString(article.id, encodedArticle);
    }
  }

  readArticles() async {
    print('get articles');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('articles') ?? '');
  }

  readArticle(String id) async {
    print('get article $id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(id) ?? '');
  }

  void addArticle(ArticleInsert article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var articles = prefs.getStringList('article_insert') ?? [];
    articles.add(json.encode(article));

    log(articles.toString());

    prefs.setStringList('article_insert', articles);
  }
}
