import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../global/global_parameters.dart';
import '../models/song.dart';
import '../constants.dart';
import 'more_bottom_sheet.dart';
// import 'player_wave.dart';

part 'bottom_music_player.dart';

part 'middle_music_player.dart';

part 'top_music_player.dart';

part 'song_slider.dart';

part 'gradient_rect_slider_track_shape.dart';

part 'player_controls.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({
    Key? key,
    required this.backgroundBody,
  }) : super(key: key);

  final Widget backgroundBody;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<double> topPlayerOpacity;
  late ValueNotifier<double> middlePlayerOpacity;
  late ValueNotifier<double> bottomPlayerOpacity;
  late ValueNotifier<int> progress;
  late Animation<double> _xTween;
  late Animation<double> _yTween;
  late Animation<double> _radiusTween;

  @override
  void initState() {
    topPlayerOpacity = ValueNotifier(0.0);
    middlePlayerOpacity = ValueNotifier(0.0);
    bottomPlayerOpacity = ValueNotifier(1.0);
    progress = ValueNotifier(0);
    GlobalParameters.radiusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _xTween = Tween<double>(begin: 0.0, end: 1.0)
        .animate(GlobalParameters.radiusController);
    _radiusTween = Tween<double>(begin: 0.35, end: 1.5)
        .animate(GlobalParameters.radiusController);
    super.initState();
  }

  void initTween(
      {required double halfOfHeight,
      required double paddingTop,
      required double firstSizedBox,
      required double firstContainer,
      required double secondSizedBox,
      required double bigCircleRadius}) {
    double begin = (-halfOfHeight +
            paddingTop +
            firstSizedBox +
            firstContainer +
            secondSizedBox +
            bigCircleRadius) /
        halfOfHeight;
    _yTween = Tween<double>(begin: begin, end: -1.0)
        .animate(GlobalParameters.radiusController);
  }

  @override
  void dispose() {
    GlobalParameters.radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double safeHeight = size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    const  double firstSizedBox = 10.0;
    const  double firstContainer = 45.0;
    final  double secondSizedBox = safeHeight * 0.1;
    const  double bigCircleRadius = 107.0;
    initTween(
      halfOfHeight: size.height / 2,
      paddingTop: MediaQuery.of(context).padding.top,
      firstSizedBox: firstSizedBox,
      firstContainer: firstContainer,
      secondSizedBox: secondSizedBox,
      bigCircleRadius: bigCircleRadius,
    );
    return SnappingSheet(
      controller: GlobalParameters.snappingSheetController,
      initialSnappingPosition: const SnappingPosition.pixels(
          positionPixels: ConstantData.bottomPlayerHeight),
      lockOverflowDrag: true,
      child: Stack(
        children: [
          SafeArea(
            child: widget.backgroundBody,
          ),
          ValueListenableBuilder(
            valueListenable: bottomPlayerOpacity,
            builder: (context, double percent, child) {
              return Visibility(
                visible: (percent == 1) ? false : true,
                child: Opacity(
                  opacity: (1.0 - percent) / 4,
                  child: GestureDetector(
                    onTap: () {
                      GlobalParameters.snappingSheetController
                          .snapToPosition(ConstantData.snappingPositions[0]);
                    },
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      snappingPositions: ConstantData.snappingPositions,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ValueListenableBuilder(
              valueListenable: GlobalParameters.currentSong,
              builder: (context, _, __) {
                return Stack(
                  children: [
                    FutureBuilder(
                      future:
                          GlobalParameters.currentSong.value.generateColors(),
                      builder: (context, snapshot) {
                        return AnimatedBuilder(
                            animation: _xTween,
                            builder: (context, child) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  gradient: RadialGradient(
                                    colors: [
                                      GlobalParameters
                                              .currentSong.value.firstColor ??
                                          Theme.of(context)
                                              .scaffoldBackgroundColor,
                                      GlobalParameters
                                              .currentSong.value.secondColor
                                              ?.withOpacity(0) ??
                                          Theme.of(context)
                                              .scaffoldBackgroundColor,
                                    ],
                                    center:
                                        Alignment(_xTween.value, _yTween.value),
                                    radius: _radiusTween.value,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: topPlayerOpacity,
                            builder: (context,double percent, child) {
                              return Visibility(
                                visible: (percent == 0) ? false : true,
                                child: Opacity(
                                  opacity: percent,
                                  child: TopMusicPlayer(
                                    safeHeight: safeHeight,
                                    firstSizedBox: firstSizedBox,
                                    firstContainer: firstContainer,
                                    secondSizedBox: secondSizedBox,
                                    bigCircleRadius: bigCircleRadius,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: middlePlayerOpacity,
                            builder: (context,double percent, child) {
                              return Visibility(
                                visible: (percent == 0) ? false : true,
                                child: Opacity(
                                  opacity: percent,
                                  child: const MiddleMusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: bottomPlayerOpacity,
                      builder: (context,double percent, child) {
                        return Visibility(
                          visible: (percent == 0) ? false : true,
                          child: Opacity(
                            opacity: percent,
                            child: BottomMusicPlayer(
                              opacityNotifier: bottomPlayerOpacity,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
      onSnapCompleted: (sheetPosition, snappingPosition) {
        if (sheetPosition.pixels == ConstantData.bottomPlayerHeight) {
          bottomPlayerOpacity.value = 1.0;
          middlePlayerOpacity.value = 0.0;
          topPlayerOpacity.value = 0.0;
        } else if (sheetPosition.pixels == ConstantData.middlePlayerHeight) {
          bottomPlayerOpacity.value = 0.0;
          middlePlayerOpacity.value = 1.0;
          topPlayerOpacity.value = 0.0;
        } else {
          bottomPlayerOpacity.value = 0.0;
          middlePlayerOpacity.value = 0.0;
          topPlayerOpacity.value = 1.0;
        }
      },
      onSheetMoved: (sheetPosition) {
        if (sheetPosition.pixels <= ConstantData.middlePlayerHeight) {
          double hundredPercent =
              ConstantData.middlePlayerHeight - ConstantData.bottomPlayerHeight;
          double percent = hundredPercent -
              sheetPosition.pixels +
              ConstantData.bottomPlayerHeight;
          bottomPlayerOpacity.value = percent / hundredPercent;
          middlePlayerOpacity.value = 1.0 - bottomPlayerOpacity.value;
        } else if (sheetPosition.pixels <= size.height) {
          double hundredPercent = size.height - ConstantData.middlePlayerHeight;
          double percent = hundredPercent -
              sheetPosition.pixels +
              ConstantData.middlePlayerHeight;
          middlePlayerOpacity.value = percent / hundredPercent;
          topPlayerOpacity.value = 1.0 - middlePlayerOpacity.value;
        } else {
          // ignore: avoid_print
          print(sheetPosition.pixels);
        }
      },
    );
  }
}
