import 'package:codeine/models/song.dart';
import 'package:flutter/material.dart';

class BottomMusicPlayer extends StatelessWidget {
  final ValueNotifier<Song> songNotifier = ValueNotifier(Song());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).splashColor,
                Theme.of(context).splashColor.withOpacity(0.0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    songNotifier.value?.title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${songNotifier.value.artists.sublist(1).fold<String>(songNotifier.value.artists.first, (prev, next) => prev += ', ' + next)}' +
                        ((songNotifier.value.feat.isNotEmpty)
                            ? ' feat ' +
                                songNotifier.value.feat.sublist(1).fold<String>(
                                    songNotifier.value.feat.first,
                                    (prev, next) => prev += ', ' + next)
                            : ''),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.play_arrow,
                  size: 28,
                ),
                color: Theme.of(context).focusColor,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
