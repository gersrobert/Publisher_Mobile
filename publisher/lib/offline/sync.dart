import 'dart:convert';

import 'package:publisher/DTO/Article.dart';
import 'package:publisher/DTO/Articles.dart';
import 'package:publisher/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineSync {
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
}
