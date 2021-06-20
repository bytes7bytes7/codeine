import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.controller,
    @required this.label,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.transparent,
      shadowColor: Theme.of(context).focusColor,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.subtitle1,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
