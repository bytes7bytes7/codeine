import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:codeine/global/global_parameters.dart';
import 'package:codeine/models/user.dart';
import 'package:codeine/widgets/music_player.dart';
import 'package:codeine/widgets/music_sliver.dart';
import 'package:codeine/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        gradient: RadialGradient(
          colors: [
            Theme.of(context).highlightColor,
            Theme.of(context).highlightColor.withOpacity(0),
          ],
          center: Alignment.topCenter,
          radius: 0.9,
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: MusicPlayer(
            backgroundBody: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                _Header(),
                SearchBar(
                  controller: textEditingController,
                ),
                MusicSliver(
                  trackTitle: 'Мои треки',
                  playlists: GlobalParameters.playlists,
                  songs: GlobalParameters.songs,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline3.copyWith(
                  fontSize: 25,
                  shadows: [
                    Shadow(
                      blurRadius: 7.0,
                      color: Theme.of(context).focusColor,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText(
                      'CODEINE',
                      speed: Duration(seconds: 8),
                    ),
                  ],
                  pause: Duration(milliseconds: 0),
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
            // SizedBox(
            //   width: 250.0,
            //   child: AnimatedTextKit(
            //     animatedTexts: [
            //       ColorizeAnimatedText(
            //         'CODEINE',
            //         textStyle: Theme.of(context)
            //             .textTheme
            //             .headline3
            //             .copyWith(fontSize: 25),
            //         colors: [
            //           Theme.of(context).focusColor,
            //           Theme.of(context).splashColor,
            //         ],
            //         speed: Duration(seconds: 2),
            //       ),
            //       ColorizeAnimatedText(
            //         'CODEINE',
            //         textStyle: Theme.of(context)
            //             .textTheme
            //             .headline3
            //             .copyWith(fontSize: 25),
            //         colors: [
            //           Theme.of(context).focusColor,
            //           Theme.of(context).splashColor,
            //         ],
            //         speed: Duration(seconds: 2),
            //       ),
            //     ],
            //     isRepeatingAnimation: true,
            //     repeatForever: true,
            //     pause: Duration(milliseconds: 100),
            //     onTap: () {
            //       print("Tap Event");
            //     },
            //   ),
            // ),
            // Text(
            //   'CODEINE',
            //   style:
            //       Theme.of(context).textTheme.headline3.copyWith(fontSize: 25),
            // ),
            Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).splashColor,
              child: ClipOval(
                child: Image.network(
                  User.photo,
                  errorBuilder: (context, object, stackTrace) {
                    return Icon(Icons.person);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
