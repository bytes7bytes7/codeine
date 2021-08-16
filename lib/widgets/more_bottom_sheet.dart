import 'dart:ui';
import 'package:flutter/material.dart';

import '../global/global_parameters.dart';
import '../global/typedefs.dart';

void showMoreBottomSheet({
  required BuildContext context,
}) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).focusColor,
                    blurRadius: 8,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GlobalParameters.currentSong.value.firstColor!,
                          GlobalParameters.currentSong.value.firstColor!
                              .withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          GlobalParameters.currentSong.value.title!,
                          style: Theme.of(context).textTheme.headline3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          GlobalParameters.currentSong.value.artists.sublist(1).fold<String>(GlobalParameters.currentSong.value.artists.first.name!, (prev, next) => prev += ', ' + next.name!),
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  (GlobalParameters.currentSong.value.artists.length == 1)
                      ? _OptionLine(
                          icon: Icons.person_outline_outlined,
                          text: GlobalParameters
                              .currentSong.value.artists.first.name!,
                          onPressed: () {},
                        )
                      : _OptionLine(
                          icon: Icons.person_outline_outlined,
                          text: 'Артисты',
                          onPressed: () {},
                        ),
                  _OptionLine(
                    icon: Icons.playlist_play_outlined,
                    text: 'Открыть плейлист',
                    onPressed: () {},
                  ),
                  _OptionLine(
                    icon: Icons.playlist_add_outlined,
                    text: 'Добавить в плейлист',
                    onPressed: () {},
                  ),
                  _OptionLine(
                    icon: Icons.download,
                    text: 'Сохранить',
                    onPressed: () {},
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

class _OptionLine extends StatelessWidget {
  const _OptionLine({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidFunction onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: GlobalParameters.currentSong.value.secondColor,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
