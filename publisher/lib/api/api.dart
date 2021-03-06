import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:publisher/auth/auth.dart';
import 'package:http/http.dart' as http;

class Api {
  Api._privateConstructor() {}

  static final Api _instance = Api._privateConstructor();

  factory Api() {
    return _instance;
  }

  Future<http.Response> getArticles(int pageNumber,
      [String author, String title, String category]) async {
    author ??= '';
    title ??= '';
    category ??= '';

    var queryParameters = {
      "page": "$pageNumber",
    };

    if (author.isNotEmpty) {
      queryParameters["author"] = author;
    }
    if (title.isNotEmpty) {
      queryParameters["title"] = title;
    }
    if (category.isNotEmpty) {
      queryParameters["category"] = category;
    }

    var headers;
    if (Auth().getLoginStatus()) {
      headers = {
        HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
      };
    }

    return http.get(
      Uri.http('${env['HOST']}:${env['PORT']}', 'article', queryParameters),
      headers: headers,
    );
  }

  Future<http.Response> deleteArticle(String id) async {
    if (!Auth().getLoginStatus()) {
      throw Exception('forbidden');
    }
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
    };

    return http.delete(
      Uri.http('${env['HOST']}:${env['PORT']}', 'article/$id'),
      headers: headers,
    );
  }

  Future<http.Response> getAuthenticatedUser() async {
    if (!Auth().getLoginStatus()) {
      throw Exception('Not Logged in.');
    }

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
    };

    return http.get(
      Uri.http('${env['HOST']}:${env['PORT']}', 'user'),
      headers: headers,
    );
  }

  Future<http.Response> getUser(String userId) async {
    if (!Auth().getLoginStatus()) {
      throw Exception('Not Logged in.');
    }

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
    };

    return http.get(
      Uri.http('${env['HOST']}:${env['PORT']}', 'user/$userId'),
      headers: headers,
    );
  }

  Future<http.Response> getDetailedArticle(String id) async {
    var headers;
    if (Auth().getLoginStatus()) {
      headers = {
        HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
      };
    }

    return http.get(Uri.http('${env['HOST']}:${env['PORT']}', 'article/$id'),
        headers: headers);
  }

  Future<http.Response> addComment(String articleId, String commentText) async {
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    return http.post(
        Uri.http(
            '${env['HOST']}:${env['PORT']}', '/article/$articleId/comment'),
        headers: headers,
        body: jsonEncode({"content": commentText}));
  }

  Future<http.Response> addArticle(
      String title, String content, List<String> categories) async {
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    var body = {'title': title, 'content': content, 'categories': categories};

    return http.post(Uri.http('${env['HOST']}:${env['PORT']}', '/article'),
        headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> updateArticle(
      String id, String title, String content, List<String> categories) async {
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    var body = {'title': title, 'content': content, 'categories': categories};

    return http.put(Uri.http('${env['HOST']}:${env['PORT']}', '/article/$id'),
        headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> uploadPhoto(String photo) async {
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}"
    };

    return http.put(Uri.http('${env['HOST']}:${env['PORT']}', 'user/set_photo'),
        headers: headers, body: jsonEncode(photo));
  }
}
