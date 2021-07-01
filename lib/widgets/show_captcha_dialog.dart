import 'package:codeine/constants.dart';
import 'package:codeine/services/auth_service.dart';
import 'package:codeine/widgets/input_field.dart';
import 'package:flutter/material.dart';

Future<void> showCaptchaDialog({BuildContext context}) async {
  final TextEditingController captchaController = TextEditingController();
  final ValueNotifier<String> errorNotifier = ValueNotifier(null);

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // true - user can dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.all(0),
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).focusColor.withOpacity(0.2),
                  Theme.of(context).focusColor.withOpacity(0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Введите код\nс картинки',
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 25),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${ConstantHTTP.vkURL}captcha.php?sid=${AuthService.captchaSID}&s=1',
                            width: 190.0,
                            height: 70.0,
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          ),
                        ),
                        SizedBox(height: 30),
                        InputField(
                          controller: captchaController,
                          errorNotifier: errorNotifier,
                          hint: 'Код',
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                'Отмена',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Ок',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
