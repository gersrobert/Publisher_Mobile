import 'package:flutter/material.dart';
import 'package:publisher/DTO/Article.dart';

class Categories extends StatelessWidget {
  Categories(this.article);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        article.categories.length,
        (index) {
          if (index < 2) {
            return Container(
              margin: EdgeInsets.only(
                left: 2,
                right: 2,
                top: 4,
                bottom: 8,
              ),
              child: Chip(
                label: Text(
                  article.categories[index].name,
                ),
              ),
            );
          } else if (index == 2) {
            return new Container(
              margin: EdgeInsets.only(
                left: 2,
                right: 2,
                top: 4,
                bottom: 8,
              ),
              child: Chip(
                label: Text(
                  "+${article.categories.length - 2}",
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
