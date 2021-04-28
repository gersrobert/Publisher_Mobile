import 'package:flutter/material.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/screens/articles/articlesPage.dart';

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
              child: InputChip(
                label: Text(
                  article.categories[index].name,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArticlesPage(
                        category: article.categories[index].name,
                      ),
                    ),
                  );
                },
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
