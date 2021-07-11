import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/widgets/player_wave.dart';
import 'package:flutter/material.dart';
import 'package:codeine/constants.dart';
import 'package:codeine/global/global_parameters.dart';

part 'bottom_music_player.dart';
part 'middle_music_player.dart';
part 'top_music_player.dart';
part 'song_slider.dart';
part 'gradient_rect_slider_track_shape.dart';
part 'player_controls.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({
    Key key,
    @required this.backgroundBody,
  }) : super(key: key);

  final Widget backgroundBody;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final ValueNotifier<double> topPlayerOpacity = ValueNotifier(0.0);
  final ValueNotifier<double> middlePlayerOpacity = ValueNotifier(0.0);
  final ValueNotifier<double> bottomPlayerOpacity = ValueNotifier(1.0);
  final ValueNotifier<int> progress = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SnappingSheet(
      controller: GlobalParameters.snappingSheetController,
      initialSnappingPosition: SnappingPosition.pixels(
          positionPixels: ConstantData.bottomPlayerHeight),
      lockOverflowDrag: true,
      child: Stack(
        children: [
          SafeArea(
            child: widget.backgroundBody,
          ),
          ValueListenableBuilder(
            valueListenable: bottomPlayerOpacity,
            builder: (context, percent, child) {
              return Visibility(
                visible: (percent == 1) ? false : true,
                child: Opacity(
                  opacity: (1.0 - percent) / 4,
                  child: GestureDetector(
                    onTap: () {
                      GlobalParameters.snappingSheetController.snapToPosition(ConstantData.snappingPositions[0]);
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
            borderRadius: BorderRadius.only(
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
                      future: GlobalParameters.currentSong.value.generateColors(),
                      builder: (context, snapshot) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            gradient: LinearGradient(
                              colors: [
                                GlobalParameters.currentSong.value.firstColor ?? Theme.of(context).scaffoldBackgroundColor,
                                GlobalParameters.currentSong.value.secondColor?.withOpacity(0) ?? Theme.of(context).scaffoldBackgroundColor,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        );
                      }
                  ),
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: topPlayerOpacity,
                          builder: (context, percent, child) {
                            return Visibility(
                              visible: (percent == 0) ? false : true,
                              child: Opacity(
                                opacity: percent,
                                child: TopMusicPlayer(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: middlePlayerOpacity,
                          builder: (context, percent, child) {
                            return Visibility(
                              visible: (percent == 0) ? false : true,
                              child: Opacity(
                                opacity: percent,
                                child: MiddleMusicPlayer(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: bottomPlayerOpacity,
                    builder: (context, percent, child) {
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
            }
          ),
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
          print(sheetPosition.pixels);
        }
      },
    );
  }
}
