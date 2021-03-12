import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 40.0),
                      child: ElevatedButton(
                          child: Text('LOGIN'),
                          onPressed: () {
                            loginAction();
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}


// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:publisher/auth/auth.dart';
// import 'package:publisher/auth/registerPage.dart';
// // import 'package:publisher/publisher/homePage.dart';
// import 'package:publisher/DTO/AppUserDTO.dart';

// // import 'dart:convert';
// // import 'package:publisher/DTO/album.dart';

//   // void _fetchNextAlbum() {
//   //   setState(() {
//   //     futureAlbum = fetchAlbum(_counter++);
//   //   });
//   // }

//   //           FutureBuilder<Album>(
//   //           future: futureAlbum,
//   //           builder: (context, snapshot) {
//   //             if (snapshot.hasData) {
//   //               return Text(snapshot.data.title);
//   //             } else if (snapshot.hasError) {
//   //               return Text("${snapshot.error}");
//   //             }
//   //             return CircularProgressIndicator();
//   //           },
//   //         ),

// // Future<Album> fetchAlbum(int counter) async {
// //   final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/$counter'));

// //   if (response.statusCode == 200) {
// //     // If the server did return a 200 OK response,
// //     // then parse the JSON.
// //     return Album.fromJson(jsonDecode(response.body));
// //   } else {
// //     // If the server did not return a 200 OK response,
// //     // then throw an exception.
// //     throw Exception('Failed to load album');
// //   }
// // }

// Future<AppUserDTO> fetchTest() async {
//   final response = await http.get(Uri.http('localhost:10420', 'user/test'));

//   if (response.statusCode == 200) {
//     return AppUserDTO.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed');
//   }
// }

// class LoginPage extends StatefulWidget {
//   LoginPage({Key key}) : super(key: key);
  
//   final String title = "Login"; 
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends AuthState<LoginPage> {
//   var _username = TextControllerWrapper('Username');
//   var _password = PasswordControllerWrapper('Password');

//   String _info = '';
//   Future<AppUserDTO> _user;

//   // void _login() {
//   //   setState((){
//   //     _username.setValue();
//   //     _password.setValue();
//   //   });

//   //   if (_username.value == 'Bobo' && _password.value == 'heslo') {
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => HomePage())
//   //     );
//   //   }
//   // }

//   void _register() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => RegisterPage()),
//     );
//   }

//   void _fetchTest() {
//     setState(() {
//       _user = fetchTest();
//     });
//   }
  
//   @override
//   void dispose() {
//     _username.controller.dispose();
//     _password.controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 getTextBox(_username),
//                 getPasswordBox(_password),
//                 Text('$_info'),
//                 Text('${_username.value}'),
//                 Text('${_password.value}'),
//                 FutureBuilder<AppUserDTO>(
//                   future: _user,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Text(snapshot.data.id);
//                     } else if (snapshot.hasError) {
//                       return Text("${snapshot.error}");
//                     }
//                     return CircularProgressIndicator();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: Row(
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(10.0),
//               child: ElevatedButton(
//                 child: Text('Register'),
//                 onPressed: _register,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(10.0),
//               child: ElevatedButton(
//                 child: Text('Login'),
//                 onPressed: _fetchTest
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }