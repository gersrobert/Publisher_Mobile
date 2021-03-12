import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/DTO/AppUserWithPasswordDTO.dart';

Future<String> createUser(
    String userName, String firstName, String lastName, String password) async {
  AppUserWithPasswordDTO user = AppUserWithPasswordDTO(
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      passwordHash: sha256.convert(utf8.encode(password)).toString());

  final response = await http.post(
    Uri.http('localhost:10420', 'user/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    return 'Registration was successful.';
  } else {
    throw Exception('Registration failed.');
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  final String title = "Register";
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends AuthState<RegisterPage> {
  var _username = TextControllerWrapper('Username');
  var _firstname = TextControllerWrapper('Firstname');
  var _lastname = TextControllerWrapper('Lastname');
  var _password1 = PasswordControllerWrapper('Password');
  var _password2 = PasswordControllerWrapper('Password one more time');

  String _info = '';

  void _register() {
    _username.setValue();
    _firstname.setValue();
    _lastname.setValue();
    _password1.setValue();
    _password2.setValue();

    if (_username.value.isEmpty ||
        _firstname.value.isEmpty ||
        _lastname.value.isEmpty ||
        _password1.value.isEmpty ||
        _password2.value.isEmpty) {
      setState(() {
        _info = 'Enter all values';
      });
      return;
    }

    if (_password1.value != _password2.value) {
      setState(() {
        _info = 'Passwords do not match';
      });
      return;
    }
    setState(() {
      _info = '';
    });
    createUser(
        _username.value, _firstname.value, _lastname.value, _password1.value);
  }

  @override
  void dispose() {
    _username.controller.dispose();
    _firstname.controller.dispose();
    _lastname.controller.dispose();
    _password1.controller.dispose();
    _password2.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getTextBox(_username),
                getTextBox(_firstname),
                getTextBox(_lastname),
                getPasswordBox(_password1),
                getPasswordBox(_password2),
                Text('$_info'),
                Text('${_username.value}'),
                Text('${_firstname.value}'),
                Text('${_lastname.value}'),
                Text('${_password1.value}'),
                Text('${_password2.value}'),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child:
                  ElevatedButton(child: Text('Register'), onPressed: _register),
            ),
          ),
        ],
      ),
    );
  }
}
