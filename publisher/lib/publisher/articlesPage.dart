import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/DTO/Articles.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/customWidgets/pAppBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:publisher/publisher/detailedArticlePage.dart';

class ArticlesPage extends StatefulWidget {
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
      var queryParameters = {"page": "$_pageNumber"};
   
      var headers;
      if (Auth().getLoginStatus()) {
        headers = {
          HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
        };
      }

      final response = await http.get(
        Uri.http('${env['HOST']}:${env['PORT']}', 'article', queryParameters),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Invalid response code');
      }
   
      Articles fetchedArticles = Articles.fromJson(jsonDecode(response.body));

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
                    child:
                        Text("Error while loading articles, tap to try again"),
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
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: TextButton(
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
                        child: Text(
                          "${article.title}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    child: Container(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'By ${article.author.firstName} '
                                '${article.author.lastName} '
                                '| ${article.createdAt.substring(8, 10)}.'
                                '${article.createdAt.substring(5, 7)}',
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 40.0,
                                ),
                              ),
                              Text('${article.likeCount} likes'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return Container();
  }
}
