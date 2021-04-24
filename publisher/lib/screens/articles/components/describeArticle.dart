import 'package:flutter/material.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/screens/detailedArticlePage.dart';

void describeArticle(BuildContext context, Article article) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailedArticlePage(
                        id: article.id,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${article.title}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: List.generate(article.categories.length, (index) {
                    return Chip(
                      label: Text(
                        article.categories[index].name,
                      ),
                    );
                  }),
                ),
              )
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children:
              //             List.generate(article.categories.length, (index) {
              //           return Container(
              //             margin: EdgeInsets.only(
              //               left: 2,
              //               right: 2,
              //               top: 4,
              //               bottom: 8,
              //             ),
              //             child: Chip(
              //               label: Text(
              //                 article.categories[index].name,
              //               ),
              //             ),
              //           );
              //         }),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    },
  );
}
