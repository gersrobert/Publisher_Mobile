import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/publisher/homePage.dart';
import 'package:publisher/publisher/profilePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth().renewRefreshToken();
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Auth0 Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/profile': (context) => Profile(),
        },
      ),
    );
  }
}
