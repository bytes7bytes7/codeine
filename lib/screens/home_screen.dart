import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../models/user.dart';
import '../services/music_service.dart';
import '../widgets/music_player.dart';
import '../widgets/music_sliver.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _yTween;

  @override
  void initState() {
    MusicService.getAllMusic();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _yTween = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > size.height && _animationController.status == AnimationStatus.reverse) {
        _animationController.forward();
      }else if(_scrollController.position.pixels <= size.height && _animationController.status == AnimationStatus.forward){
        _animationController.reverse();
      }
    });
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
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const _Header(),
                SearchBar(
                  controller: textEditingController,
                ),
                MusicSliver(
                  goUpAnimation: _yTween,
                  trackTitle: 'Мои треки',
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
    Key? key,
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
                style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontSize: 25,
                  shadows: [
                    Shadow(
                      blurRadius: 7.0,
                      color: Theme.of(context).focusColor,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText(
                      'CODEINE',
                      speed: const Duration(seconds: 8),
                    ),
                  ],
                  pause: const Duration(milliseconds: 0),
                  onTap: () {
                    // ignore: avoid_print
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
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).splashColor,
              child: ClipOval(
                child: Image.network(
                  // TODO: case when user has no photo
                  User.photo!,
                  errorBuilder: (context, object, stackTrace) {
                    return const Icon(Icons.person);
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
