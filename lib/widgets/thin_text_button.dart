import 'package:flutter/material.dart';
import '../global/typedefs.dart';

class ThinTextButton extends StatelessWidget {
  const ThinTextButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);


  final String text;
  final VoidFunction onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor.withOpacity(0.3),
        highlightColor: Theme.of(context).splashColor.withOpacity(0.3),
        onTap: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
