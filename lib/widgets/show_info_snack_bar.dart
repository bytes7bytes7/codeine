import 'package:flutter/material.dart';

void showInfoSnackBar(BuildContext context, String info, IconData icon) {
  Size size = MediaQuery.of(context).size;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 30, left: 34, right: 34),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      content: Row(
        children: [
          Container(
            width: size.width * 0.65,
            child: Text(
              info,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Spacer(),
          Icon(
            icon,
            color: Theme.of(context).focusColor,
          ),
        ],
      ),
    ),
  );
}
