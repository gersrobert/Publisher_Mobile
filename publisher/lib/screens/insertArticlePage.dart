import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:publisher/DTO/DetailedArticle.dart';
import 'package:publisher/api/api.dart';
import 'package:publisher/components/customAppBar.dart';

class InsertArticlePage extends StatefulWidget {
  final String id;

  InsertArticlePage({Key key, this.id}) : super(key: key);

  @override
  _InsertArticlePage createState() => _InsertArticlePage();
}

class _InsertArticlePage extends State<InsertArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  List<String> _categories = [];

  DetailedArticle _article;

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      getArticle(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: getBody(),
    );
  }

  void getArticle(String id) async {
    var response = await Api().getDetailedArticle(id);
    _article = DetailedArticle.fromJson(
        jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));

    _titleController.text = _article.title;
    _contentController.text = _article.content;

    setState(() {
      for (var category in _article.categories) {
        _categories.add(category.name);
      }
    });
  }

  Widget getBody() {
    return Container(
        margin: EdgeInsets.only(top: 16, left: 8, right: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      labelText: "Title", hintText: "Set title"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The title cannot be empty';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                Row(
                  children: List.generate(_categories.length + 1, (index) {
                    return new Container(
                        margin: EdgeInsets.only(
                            left: 2, right: 2, top: 4, bottom: 8),
                        child: index == _categories.length
                            ? ActionChip(
                                label: Icon(Icons.add),
                                onPressed: () {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return getCategoryAddDialog();
                                      });
                                },
                              )
                            : Chip(
                                label: Text(_categories[index]),
                                onDeleted: () {
                                  setState(() {
                                    _categories.removeAt(index);
                                  });
                                },
                              ));
                  }),
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                      labelText: "Content", hintText: "Set content"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The content cannot be empty';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          onPressed: submitForm, child: Text('Submit')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  AlertDialog getCategoryAddDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 0.6,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          controller: _categoryController,
          decoration: const InputDecoration(
              labelText: "Category", hintText: "Set cateogry name"),
          validator: (value) {
            if (value.isEmpty) {
              return 'The category cannot be empty';
            }
            return null;
          },
          maxLines: 1,
        ),
        Row(
          children: [
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 8, right: 4),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _categoryController.clear();
                  },
                  child: Text("Cancel")),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, left: 4),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_categoryController.text.isNotEmpty) {
                        _categories.add(_categoryController.text);
                        _categoryController.clear();
                      }
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Add")),
            ),
          ],
        )
      ]),
    );
  }

  Future<void> submitForm() async {
    if (_formKey.currentState.validate()) {
      var response;
      if (widget.id == null) {
        response = await Api().addArticle(
            _titleController.text, _contentController.text, _categories);
      } else {
        response = await Api().updateArticle(widget.id, _titleController.text,
            _contentController.text, _categories);
      }

      if (response.statusCode == 200) {
        Navigator.maybePop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 232, 39, 5),
          content: Text(
              "Error trying to ${widget.id == null ? 'insert' : 'update'} article"),
        ));
      }
    }
  }
}
