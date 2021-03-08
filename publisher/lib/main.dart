import 'package:flutter/material.dart';
import 'auth/loginPage.dart';
import 'publisher/homePage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  StatefulWidget _getInitPage() {
    bool loggedIn = false;

    if (loggedIn) {
      return HomePage();
    }
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'A3cle Publisher',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: _getInitPage(),
    );
  }
}