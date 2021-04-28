import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/DTO/Articles.dart';
import 'package:publisher/components/categories.dart';
import 'package:publisher/screens/articles/components/customAppBar.dart';
import 'package:publisher/screens/articles/components/describeArticle.dart';
import 'package:publisher/screens/articles/components/authorAndDate.dart';
import 'package:publisher/components/likeWidget.dart';
import 'package:publisher/screens/detailedArticlePage.dart';
import 'package:publisher/api/api.dart';

class ArticlesPage extends StatefulWidget {
  final String author;
  final String title;
  final String category;

  const ArticlesPage({
    Key key,
    this.author,
    this.title,
    this.category,
  }) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  bool _hasMore = true;
  int _pageNumber;
  int _totalPages;
  bool _error;
  bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  List<Article> _articles;
  final int _nextPageThreshold = 5;
  DateFormat dateFormat = new DateFormat("dd. MM. yyyy");

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 0;
    _totalPages = 0;
    _error = false;
    _loading = true;
    _articles = [];
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: getBody(),
    );
  }

  void getArticles() async {
    if (_totalPages != 0 && _pageNumber > _totalPages) {
      return;
    }

    try {
      var response = await Api().getArticles(
        _pageNumber,
        widget.author,
        widget.title,
        widget.category,
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid response code');
      }

      Articles fetchedArticles = Articles.fromJson(
          jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));

      setState(() {
        _hasMore = fetchedArticles.content.length == _defaultPhotosPerPageCount;
        _loading = false;
        _pageNumber += 1;
        _totalPages = fetchedArticles.totalPages;
        _articles.addAll(fetchedArticles.content);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Widget getBody() {
    if (_articles.isEmpty) {
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
              getArticles();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading articles, tap to try again"),
          ),
        ));
      }
    } else {
      return ListView.builder(
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _articles.length - _nextPageThreshold) {
            getArticles();
          }
          if (index == _articles.length) {
            if (_error) {
              return Center(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    _loading = true;
                    _error = false;
                    getArticles();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Error while loading articles, tap to try again"),
                ),
              ));
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          final Article article = _articles[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                color: Colors.grey,
                width: 0.4,
              ),
            ),
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: TextButton(
                    onLongPress: () {
                      return describeArticle(context, article);
                    },
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailedArticlePage(
                            id: article.id,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${article.title}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Categories(article),
                          AuthorAndDate(article),
                        ],
                      ),
                      Spacer(),
                      LikeWidget(
                        id: article.id,
                        liked: article.liked,
                        likeCount: article.likeCount,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }
}
