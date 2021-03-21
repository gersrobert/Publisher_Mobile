import 'package:flutter/material.dart';
import 'package:publisher/customWidgets/pAppBar.dart';
import 'package:publisher/auth/auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => Auth().renewRefreshToken(),
              child: Text('renew'),
            ),
            Consumer<Auth>(
              builder: (context, auth, child) {
                return Text('Status: ${auth.getLoginStatus()}');
              },
            ),
            SizedBox(height: 5.0),
            Consumer<Auth>(
              builder: (context, auth, child) {
                return Text('Access Token: ${auth.getAccessToken()}');
              },
            ),
            SizedBox(height: 5.0),
            Consumer<Auth>(
              builder: (context, auth, child) {
                return Text('Refresh Token: ${auth.getRefreshToken()}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
