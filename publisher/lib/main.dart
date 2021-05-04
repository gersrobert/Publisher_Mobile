import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publisher/auth/auth.dart';
import 'package:publisher/screens/articles/articlesPage.dart';
import 'package:publisher/screens/insertArticlePage.dart';
import 'package:publisher/screens/profilePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load();
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
        initialRoute: '/articles',
        routes: {
          '/articles': (context) => ArticlesPage(),
          '/profile': (context) => ProfilePage(),
          '/insert': (context) => InsertArticlePage(),
        },
      ),
    );
  }
}
