import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:publisher/DTO/AppUser.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/components/categories.dart';
import 'package:publisher/components/customAppBar.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/api/api.dart';
import 'package:publisher/components/likeWidget.dart';
import 'package:publisher/screens/detailedArticlePage.dart';
import 'package:publisher/screens/insertArticlePage.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({Key key, this.userId: ''}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _error;
  bool _loading;
  AppUser _user;
  bool _owner;

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;
    _owner = false;
    _user = AppUser('', 'Firstname', 'Lastname', '', [], '');
    getUser();
  }

  void getUser() async {
    if (widget.userId.isEmpty) {
      if (!Auth().getLoginStatus()) {
        throw Exception('invalid user');
      }

      var response;
      try {
        response = await Api().getAuthenticatedUser();

        if (response.statusCode != 200) {
          throw Exception('Invalid response code');
        }

        _user = AppUser.fromJson(
            jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));
        setState(() {
          _owner = true;
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } else {
      var response;
      try {
        response = await Api().getUser(widget.userId);

        if (response.statusCode != 200) {
          throw Exception('Invalid response code');
        }

        _user = AppUser.fromJson(
            jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));

        setState(() {
          _loading = false;
          _error = false;
        });
      } catch (e) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  void deleteArticle(String id) async {
    if (_owner) {
      try {
        setState(() {
          _loading = true;
        });
        var response = await Api().deleteArticle(id);

        if (response.statusCode != 200) {
          throw Exception('Invalid response code');
        }

        setState(() {
          _loading = false;
          _error = false;
        });
        getUser();
      } catch (e) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  void changeImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      String bytes = base64Encode(image.readAsBytesSync());

      var response = await Api().uploadPhoto(bytes);
      getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: ClipRRect(
                  child: _user.photo == null || _user.photo.isEmpty
                      ? Icon(Icons.face, size: 100)
                      : Image.memory(
                    base64Decode(_user.photo),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                onPressed: _owner == true ? changeImage : null,
              )
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                "${_user.firstName} ${_user.lastName}",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: articleList()),
          ],
        ),
      ),
    );
  }

  Widget articleList() {
    if (_user == null) {
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
              getUser();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading user, tap to try again"),
          ),
        ));
      }
    } else {
      return ListView.builder(
        itemCount: _user.articles.length,
        itemBuilder: (context, index) {
          final Article article = _user.articles[index];
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
                    onPressed: () async {
                      await Navigator.of(context).push(
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
                          _owner
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InsertArticlePage(
                                                  id: article.id,
                                                ),
                                              ),
                                            )
                                            .then(
                                              (value) => getUser(),
                                            );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 40.0,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteArticle(article.id);
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 40.0,
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
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
