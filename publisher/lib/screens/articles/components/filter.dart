import 'package:flutter/material.dart';
import 'package:publisher/screens/articles/articlesPage.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 0.6,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                    labelText: "Author", hintText: "user name"),
                maxLines: 1,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                    labelText: "Category", hintText: "name of category"),
                maxLines: 1,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: "Title", hintText: "name of title"),
                maxLines: 1,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ArticlesPage(
            author: _authorController.text,
            category: _categoryController.text,
            title: _titleController.text,
          ),
        ),
      );
    }
  }
}
