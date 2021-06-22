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
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.transparent,
        shadowColor: Theme.of(context).focusColor,
        child: ValueListenableBuilder(
          valueListenable: errorNotifier,
          builder: (context, _, __) {
            return TextFormField(
              controller: controller,
              obscureText: obscureText,
              onChanged: (value) {
                errorNotifier.value = null;
              },
              cursorColor: Theme.of(context).accentColor,
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
                        : Theme.of(context).accentColor,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
