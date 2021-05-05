import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:publisher/auth/auth.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  void _handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Login':
        Auth().loginAction();
        break;
      case 'Profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'Logout':
        Auth().logoutAction();
        break;
      case 'Add article':
        Navigator.pushNamed(context, '/insert');
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
            var _options = {'Add article', 'Login'};
            if (auth.getLoginStatus()) {
              _options = {'Add article', 'Profile', 'Logout'};
            }
            return PopupMenuButton(
              onSelected: (String value) => _handleClick(context, value),
              itemBuilder: (BuildContext context) {
                return _options.map(
                  (choice) {
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
