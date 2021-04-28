import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:publisher/DTO/DetailedArticle.dart';
import 'package:publisher/api/api.dart';
import 'package:publisher/components/customAppBar.dart';
import 'package:publisher/components/likeWidget.dart';
import 'package:publisher/screens/articles/articlesPage.dart';
import 'package:publisher/screens/profilePage.dart';

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
  DateFormat dateFormat = new DateFormat("dd. MM. yyyy");
  bool commentMode = false;

  ScrollController _scrollController = new ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

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
      final response = await Api().getDetailedArticle(widget.id);

      if (response.statusCode != 200) {
        throw Exception('Invalid response code');
      }

      setState(() {
        _loading = false;
        _article = DetailedArticle.fromJson(
            jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));

        log(_article.content);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void submitComment() async {
    if (_formKey.currentState.validate()) {
      var response = await Api().addComment(widget.id, _commentController.text);

      if (response.statusCode == 200) {
        getDetailedArticle();
        cancelComment();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 232, 39, 5),
          content: Text("Error trying to post comment"),
        ));
      }
    }
  }

  void cancelComment() {
    setState(() {
      commentMode = false;
      _commentController.clear();
    });
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
      return Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeader(),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Divider(thickness: 2),
                ),
                getContent(),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: Divider(thickness: 2),
                ),
                getComments(),
                Visibility(
                    visible: !commentMode,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              commentMode = true;
                              _scrollController.animateTo(
                                  _scrollController.position.pixels + 100,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300));
                            });
                          },
                          child: Row(
                            children: [Icon(Icons.add), Text("Add comment")],
                          ),
                        ))),
                Visibility(visible: commentMode, child: getCommentForm()),
              ],
            ),
          ));
    }
    return Container();
  }

  Widget getHeader() {
    return Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_article.title,
                style: TextStyle(
                  fontSize: 24,
                )),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        _article.categories.length,
                        (index) {
                          return new Container(
                            margin: EdgeInsets.only(
                                left: 2, right: 2, top: 4, bottom: 8),
                            child: InputChip(
                              label: Text(
                                _article.categories[index].name,
                              ),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ArticlesPage(
                                      category: _article.categories[index].name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text("By "),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    userId: _article.author.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                                "${_article.author.firstName} ${_article.author.lastName}"),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                          ),
                          Text(" | "),
                          Text(dateFormat
                              .format(DateTime.parse(_article.createdAt)))
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                LikeWidget(
                  id: _article.id,
                  liked: _article.liked,
                  likeCount: _article.likeCount,
                )
              ],
            )
          ],
        ));
  }

  Widget getContent() {
    return Container(
      child: Text(_article.content, textAlign: TextAlign.justify),
      margin: EdgeInsets.only(bottom: 16),
    );
  }

  Widget getComments() {
    return Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_article.comments.length, (index) {
              return Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${_article.comments[index].author.firstName} ${_article.comments[index].author.lastName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" | "),
                          Text(dateFormat.format(DateTime.parse(
                              _article.comments[index].createdAt))),
                        ],
                      ),
                      Text(
                        _article.comments[index].content,
                      ),
                    ],
                  ));
            }),
          ),
        ]));
  }

  Widget getCommentForm() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(hintText: "Say something"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              maxLines: null,
            ),
          ),
          Row(
            children: [
              Spacer(),
              TextButton(
                  onPressed: () {
                    cancelComment();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    submitComment();
                  },
                  child: Text("Send")),
            ],
          )
        ],
      ),
    );
  }
}
