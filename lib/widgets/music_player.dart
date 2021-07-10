import 'package:codeine/widgets/song_slider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/widgets/player_wave.dart';
import 'package:flutter/material.dart';
import 'package:codeine/constants.dart';

part 'bottom_music_player.dart';

part 'middle_music_player.dart';

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
  final ValueNotifier<double> playerOpacity = ValueNotifier(1.0);
  final ValueNotifier<double> bottomPlayerOpacity = ValueNotifier(1.0);
  final SnappingSheetController snappingSheetController =
  SnappingSheetController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SnappingSheet(
      controller: snappingSheetController,
      initialSnappingPosition:
          SnappingPosition.pixels(positionPixels: ConstantData.playerHeight),
      lockOverflowDrag: true,
      child: SafeArea(
        child: widget.backgroundBody,
      ),
      snappingPositions: ConstantData.snappingPositions,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2CDEFF),
                  Color(0x0026FF56),
                ],
                begin: Alignment.topRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: bottomPlayerOpacity,
                        builder: (context, percent, child) {
                          return Opacity(
                            opacity: 1.0 - percent,
                            child: MiddleMusicPlayer(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: bottomPlayerOpacity,
                  builder: (context, percent, child) {
                    return Opacity(
                      opacity: percent,
                      child: BottomMusicPlayer(
                        playerHeight: ConstantData.playerHeight,
                        opacityNotifier: bottomPlayerOpacity,
                        snappingSheetController: snappingSheetController,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      onSnapCompleted: (sheetPosition, snappingPosition) {
        if (sheetPosition.pixels >= ConstantData.playerHeight &&
            sheetPosition.pixels <= size.height * 0.3) {
          double hundredPercent = size.height * 0.3 - ConstantData.playerHeight;
          double percent =
              hundredPercent - sheetPosition.pixels + ConstantData.playerHeight;
          bottomPlayerOpacity.value = percent / hundredPercent;
        } else {
          bottomPlayerOpacity.value = 0.0;
        }
      },
      onSheetMoved: (sheetPosition) {
        if (sheetPosition.pixels >= ConstantData.playerHeight &&
            sheetPosition.pixels <= size.height * 0.3) {
          double hundredPercent = size.height * 0.3 - ConstantData.playerHeight;
          double percent =
              hundredPercent - sheetPosition.pixels + ConstantData.playerHeight;
          bottomPlayerOpacity.value = percent / hundredPercent;
        }
      },
    );
  }
}
