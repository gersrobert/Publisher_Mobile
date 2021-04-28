import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/screens/profilePage.dart';

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
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: article.author.id,
                  ),
                ),
              );
            },
            child:
                Text("${article.author.firstName} ${article.author.lastName}"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
          Text(" | "),
          Text(dateFormat.format(DateTime.parse(article.createdAt)))
        ],
      ),
    );
  }
}
