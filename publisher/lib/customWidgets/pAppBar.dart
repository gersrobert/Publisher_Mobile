import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:publisher/auth/auth.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  void _handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Login':
        Auth().loginAction();
        log('Pressed Login button');
        break;
      case 'Profile':
        log('Pressed Profile button');
        Navigator.pushNamed(context, '/profile');
        break;
      case 'Logout':
        Auth().logoutAction();
        log('Pressed Logout button');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Publisher'),
      actions: <Widget>[
        Consumer<Auth>(
          builder: (context, auth, child) {
            var _options = {'Login'};
            if (auth.getLoginStatus()) {
              _options = {'Profile', 'Logout'};
            }
            return PopupMenuButton(
              onSelected: (String value) => _handleClick(context, value),
              itemBuilder: (BuildContext context) {
                return _options.map(
                  (String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  },
                ).toList();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}
