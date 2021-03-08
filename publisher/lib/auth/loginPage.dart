import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/auth/registerPage.dart';
import 'package:publisher/publisher/homePage.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:publisher/DTO/album.dart';

  // void _fetchNextAlbum() {
  //   setState(() {
  //     futureAlbum = fetchAlbum(_counter++);
  //   });
  // }

  //           FutureBuilder<Album>(
  //           future: futureAlbum,
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               return Text(snapshot.data.title);
  //             } else if (snapshot.hasError) {
  //               return Text("${snapshot.error}");
  //             }
  //             return CircularProgressIndicator();
  //           },
  //         ),

// Future<Album> fetchAlbum(int counter) async {
//   final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/$counter'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  final String title = "Login"; 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  var _username = TextControllerWrapper('Username');
  var _password = PasswordControllerWrapper('Password');

  String _info = '';

  void _login() {
    setState((){
      _username.setValue();
      _password.setValue();
    });

    if (_username.value == 'Bobo' && _password.value == 'heslo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
      );
    }
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
  
  @override
  void dispose() {
    _username.controller.dispose();
    _password.controller.dispose();
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
                getPasswordBox(_password),
                Text('$_info'),
                Text('${_username.value}'),
                Text('${_password.value}'),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: Text('Register'),
                onPressed: _register,  
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: _login
              ),
            ),
          ),
        ],
      ),
    );
  }
}