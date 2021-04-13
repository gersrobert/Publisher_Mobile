import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/components/customAppBar.dart';
import 'package:http/http.dart' as http;

class InsertArticlePage extends StatefulWidget {
  InsertArticlePage({Key key}) : super(key: key);

  @override
  _InsertArticlePage createState() => _InsertArticlePage();
}

class _InsertArticlePage extends State<InsertArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: getBody(),
    );
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
                  decoration: const InputDecoration(hintText: "Set title"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The title cannot be empty';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                Row(
                  children: List.generate(categories.length + 1, (index) {
                    return new Container(
                        margin: EdgeInsets.only(
                            left: 2, right: 2, top: 4, bottom: 8),
                        child: ActionChip(
                          label: index == categories.length
                              ? Icon(Icons.add)
                              : Text(categories[index]),
                          onPressed: () {
                            if (index != categories.length) {
                              return;
                            }

                            log("add cat");
                          },
                        ));
                  }),
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(hintText: "Set content"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The content cannot be empty';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(onPressed: submitForm, child: Text('Submit')),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<void> submitForm() async {
    if (_formKey.currentState.validate()) {
      if (Auth().getLoginStatus()) {
        var headers = {
          HttpHeaders.authorizationHeader: "Bearer ${Auth().getAccessToken()}",
          HttpHeaders.contentTypeHeader: "application/json",
        };

        var body = {
          'title': _titleController.text,
          'content': _contentController.text,
          'categories': ['test']
        };

        final response = await http.post(
            Uri.http('${env['HOST']}:${env['PORT']}', '/article'),
            headers: headers,
            body: jsonEncode(body));

        if (response.statusCode == 200) {
          Navigator.maybePop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 232, 39, 5),
            content: Text("Error trying to insert article"),
          ));
        }
      }
    }
  }
}
