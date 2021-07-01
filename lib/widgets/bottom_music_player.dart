import 'package:codeine/models/song.dart';
import 'package:codeine/widgets/player_wave.dart';
import 'package:flutter/material.dart';

class BottomMusicPlayer extends StatefulWidget {
  @override
  State<BottomMusicPlayer> createState() => _BottomMusicPlayerState();
}

class _BottomMusicPlayerState extends State<BottomMusicPlayer>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Song> songNotifier;
  ValueNotifier<bool> playNotifier;
  AnimationController _playAnimationController;
  ValueNotifier<int> waveDuration;
  ValueNotifier<double> waveHeightPercentage;

  @override
  void initState() {
    waveDuration = ValueNotifier(10000);
    waveHeightPercentage = ValueNotifier(0.7);
    songNotifier = ValueNotifier(Song());
    playNotifier = ValueNotifier(false);
    _playAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _playAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: waveDuration,
                builder: (context, _, __) {
                  return PlayerWave(
                    config: CustomConfig(
                      gradients: [
                        [
                          Theme.of(context).splashColor,
                          Theme.of(context).splashColor.withOpacity(0.0),
                        ],
                        // [
                        //   Theme.of(context).splashColor,
                        //   Theme.of(context).splashColor.withOpacity(0.0),
                        // ],
                      ],
                      durations: [waveDuration.value],
                      heightPercentages: [waveHeightPercentage.value],
                      blur: MaskFilter.blur(BlurStyle.solid, 5),
                      gradientBegin: Alignment.bottomCenter,
                      gradientEnd: Alignment.topCenter,
                    ),
                    waveAmplitude: 0,
                    backgroundColor: Colors.transparent,
                    size: Size(double.infinity, 60),
                  );
                },
              ),
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                                      songNotifier.value.feat
                                          .sublist(1)
                                          .fold<String>(
                                              songNotifier.value.feat.first,
                                              (prev, next) =>
                                                  prev += ', ' + next)
                                  : ''),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Spacer(),
                    // TODO: place button on the center of songs' duration
                    IconButton(
                      color: Theme.of(context).focusColor,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      splashRadius: 20,
                      icon: ValueListenableBuilder(
                        valueListenable: playNotifier,
                        builder: (context, value, __) {
                          return AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            size: 30,
                            progress: _playAnimationController,
                            color: Theme.of(context).focusColor,
                          );
                        },
                      ),
                      onPressed: () {
                        playNotifier.value = !playNotifier.value;
                        if (playNotifier.value) {
                          waveDuration.value = 3000;
                          waveHeightPercentage.value = 0.5;
                          _playAnimationController.forward();
                        } else {
                          waveDuration.value = 10000;
                          waveHeightPercentage.value = 0.7;
                          _playAnimationController.reverse();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
