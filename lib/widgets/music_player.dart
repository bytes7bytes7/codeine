import 'package:codeine/widgets/song_slider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/widgets/player_wave.dart';
import 'package:flutter/material.dart';

part 'bottom_music_player.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final SnappingSheetController controller = SnappingSheetController();
  final double playerHeight = 60.0;
  final ValueNotifier<double> playerOpacity = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SnappingSheet(
        controller: controller,
        initialSnappingPosition:
            SnappingPosition.pixels(positionPixels: playerHeight),
        lockOverflowDrag: true,
        child: Stack(
          children: [
            Container(
              color: Colors.purple,
              height: size.height,
            ),
            ValueListenableBuilder(
              valueListenable: playerOpacity,
              builder: (context, percent, child) {
                return Opacity(
                  opacity: (1.0 - percent) / 4,
                  child: Container(
                    color: Theme.of(context).shadowColor,
                  ),
                );
              },
            ),
          ],
        ),
        snappingPositions: [
          SnappingPosition.pixels(
            positionPixels: playerHeight,
            snappingCurve: Curves.easeOutQuart,
            snappingDuration: Duration(milliseconds: 500),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.pixels(
            positionPixels: 300,
            snappingCurve: Curves.easeOutQuart,
            snappingDuration: Duration(milliseconds: 500),
          ),
          SnappingPosition.factor(
            positionFactor: 1.0,
            snappingCurve: Curves.easeOutQuart,
            snappingDuration: Duration(milliseconds: 500),
            grabbingContentOffset: GrabbingContentOffset.bottom,
          ),
        ],
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
                          valueListenable: playerOpacity,
                          builder: (context, percent, child) {
                            return Opacity(
                              opacity: 1.0 - percent,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up_outlined,
                                      color: Theme.of(context).focusColor,
                                      size: 30.0,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Diamonds',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Lil Xan',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.shuffle_outlined),
                                          color: Theme.of(context).focusColor,
                                          iconSize: 30,
                                          onPressed: () {},
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.repeat_one_outlined),
                                          color: Theme.of(context).focusColor,
                                          iconSize: 30,
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15,bottom: 10),
                                      child: SongSlider(
                                        firstColor: Color(0xFF26FF56),
                                        secondColor: Color(0xFF2CDEFF),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '1:56',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        Text(
                                          '2:49',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.fast_rewind_rounded),
                                          color: Theme.of(context).focusColor,
                                          iconSize: 60,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons
                                              .pause_circle_filled_rounded),
                                          color: Theme.of(context).focusColor,
                                          iconSize: 60,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon:
                                              Icon(Icons.fast_forward_rounded),
                                          color: Theme.of(context).focusColor,
                                          iconSize: 60,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: playerOpacity,
                    builder: (context, percent, child) {
                      return Opacity(
                        opacity: percent,
                        child: Container(
                          color: Colors.white,
                          height: playerHeight,
                          width: double.infinity,
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
          if (sheetPosition.pixels > playerHeight / 2 &&
              sheetPosition.pixels <= size.height * 0.3) {
            double hundredPercent = size.height * 0.3 - playerHeight / 2;
            double percent =
                hundredPercent - sheetPosition.pixels + playerHeight / 2;
            playerOpacity.value = percent / hundredPercent;
          } else {
            playerOpacity.value = 0.0;
          }
        },
        onSheetMoved: (sheetPosition) {
          if (sheetPosition.pixels > playerHeight / 2 &&
              sheetPosition.pixels <= size.height * 0.3) {
            double hundredPercent = size.height * 0.3 - playerHeight / 2;
            double percent =
                hundredPercent - sheetPosition.pixels + playerHeight / 2;
            playerOpacity.value = percent / hundredPercent;
          }
        },
      ),
    );
  }
}
