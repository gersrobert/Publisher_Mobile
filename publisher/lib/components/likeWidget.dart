import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:publisher/auth/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LikeWidget extends StatefulWidget {
  final String id;
  bool liked;
  int likeCount;

  LikeWidget(
      {Key key,
      @required this.id,
      @required this.liked,
      @required this.likeCount})
      : super(key: key);

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  void toggleLikeArticle() async {
    var headers;
    if (Auth().getLoginStatus()) {
      headers = {
        HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
      };
    } else {
      throw Exception('Not Logged in.');
    }

    bool _liked = widget.liked;
    int _likeCount = widget.likeCount;

    if (_liked) {
      final response = await http.put(
        Uri.http(
            '${env['HOST']}:${env['PORT']}', 'article/${widget.id}/unlike'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Invalid response code ${response.statusCode}');
      }
      _liked = false;
      _likeCount--;
    } else {
      final response = await http.put(
        Uri.http('${env['HOST']}:${env['PORT']}', 'article/${widget.id}/like'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Invalid response code ${response.statusCode}');
      }
      _liked = true;
      _likeCount++;
    }
    setState(() {
      widget.liked = _liked;
      widget.likeCount = _likeCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: toggleLikeArticle,
          child: Icon(
            widget.liked ? Icons.favorite : Icons.favorite_border,
            size: 40.0,
          ),
        ),
        Text('${widget.likeCount} likes'),
      ],
    );
  }
}
