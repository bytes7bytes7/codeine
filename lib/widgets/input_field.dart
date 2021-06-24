import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.controller,
    @required this.errorNotifier,
    @required this.hint,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueNotifier<String> errorNotifier;
  final String hint;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(
          color: Theme.of(context).focusColor.withOpacity(0.4),
          offset: Offset(0, 0),
          spreadRadius: 0,
          blurRadius: 6,
        ),
      ]),
      child: ValueListenableBuilder(
        valueListenable: errorNotifier,
        builder: (context, _, __) {
          return TextFormField(
            controller: controller,
            obscureText: obscureText,
            onChanged: (value) {
              errorNotifier.value = null;
            },
            cursorColor: Theme.of(context).splashColor,
            cursorWidth: 2,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.subtitle1,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: (errorNotifier.value != null)
                      ? Theme.of(context).errorColor
                      : Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: (errorNotifier.value != null)
                      ? Theme.of(context).errorColor
                      : Theme.of(context).splashColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}
