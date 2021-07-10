import 'package:codeine/models/playlist.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/models/user.dart';
import 'package:codeine/widgets/music_player.dart';
import 'package:codeine/widgets/music_sliver.dart';
import 'package:codeine/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomeScreen extends StatelessWidget {
  final List<Playlist> playlists = List.generate(5, (index) => Playlist());
  final List<Song> songs = List.generate(10, (index) => Song());
  final ValueNotifier<double> opacityNotifier = ValueNotifier(1.0);
  final double playerHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          body: SnappingSheet(
            lockOverflowDrag: true,
            child: SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  _Header(),
                  SearchBar(),
                  MusicSliver(
                    trackTitle: 'Мои треки',
                    playlists: playlists,
                    songs: songs,
                  ),
                ],
              ),
            ),
            snappingPositions: [
              SnappingPosition.factor(
                positionFactor: 0.0,
                snappingCurve: Curves.easeOutQuart,
                snappingDuration: Duration(milliseconds: 500),
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.pixels(
                positionPixels: size.height * 0.3,
                snappingCurve: Curves.easeOutQuart,
                snappingDuration: Duration(seconds: 1),
              ),
              SnappingPosition.factor(
                positionFactor: 1.0,
                snappingCurve: Curves.easeOutQuart,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
            ],
            grabbingHeight: playerHeight,
            grabbing: BottomMusicPlayer(
              playerHeight: playerHeight,
              opacityNotifier: opacityNotifier,
            ),
            onSnapCompleted: (sheetPosition, snappingPosition) {
              if (sheetPosition.pixels >= playerHeight / 2 &&
                  sheetPosition.pixels <= size.height * 0.3) {
                double hundredPercent = size.height * 0.3 - playerHeight / 2;
                double percent =
                    hundredPercent - sheetPosition.pixels + playerHeight / 2;
                opacityNotifier.value = percent / hundredPercent;
              }
            },
            onSheetMoved: (sheetPosition) {
              if (sheetPosition.pixels >= playerHeight / 2 &&
                  sheetPosition.pixels <= size.height * 0.3) {
                double hundredPercent = size.height * 0.3 - playerHeight / 2;
                double percent =
                    hundredPercent - sheetPosition.pixels + playerHeight / 2;
                opacityNotifier.value = percent / hundredPercent;
              }
            },
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: size.height * 0.4,
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          radius: 30,
                          foregroundColor: Colors.purple,
                        ),
                      ),
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),
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
            Text(
              'CODEINE',
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 25),
            ),
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
