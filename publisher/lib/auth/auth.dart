
import 'package:flutter/material.dart';

class TextControllerWrapper {
  String name;
  String value;
  final controller = TextEditingController();
  
  TextControllerWrapper(String name) {
    this.name = name;
  }

  void setValue() {
    value = controller.text;
  }
}

class PasswordControllerWrapper extends TextControllerWrapper {
  bool obscure = true;

  PasswordControllerWrapper(String name) : super(name);

  void flipObscure() {
    obscure = !obscure;
  }
}

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  Widget getTextBox(TextControllerWrapper wrapper) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: wrapper.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: wrapper.name
        ),
      ),
    );
  }

  Widget getPasswordBox(PasswordControllerWrapper wrapper) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: wrapper.controller,
        obscureText: wrapper.obscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: wrapper.name,
          suffixIcon: IconButton(
            onPressed: () => setState(() {wrapper.flipObscure();}),
            icon: Icon(wrapper.obscure ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined),
          )
        ),
      ),
    );
  }  
}