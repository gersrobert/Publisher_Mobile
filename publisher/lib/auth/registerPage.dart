import 'package:flutter/material.dart';
import 'package:publisher/auth/auth.dart';

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

  void _register() {
    setState(() {
      _username.setValue();
      _firstname.setValue();
      _lastname.setValue();
      _password1.setValue();
      _password2.setValue();
    });
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
              child: ElevatedButton(
                child: Text('Register'),
                onPressed: _register
              ),
            ),
          ),
        ],
      ),
    );
  }
}