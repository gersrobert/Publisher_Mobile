import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publisher/DTO/Article.dart';

class AuthorAndDate extends StatelessWidget {
  AuthorAndDate(this.article);

  final Article article;
  final DateFormat dateFormat = new DateFormat("dd. MM. yyyy");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text("By "),
          Text("${article.author.firstName} ${article.author.lastName}"),
          Text(" | "),
          Text(dateFormat.format(DateTime.parse(article.createdAt)))
        ],
      ),
    );
  }
}
