import 'package:codeine/models/playlist.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/models/user.dart';
import 'package:codeine/widgets/music_player.dart';
import 'package:codeine/widgets/music_sliver.dart';
import 'package:codeine/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Playlist> playlists = List.generate(5, (index) => Playlist());
  final List<Song> songs = List.generate(10, (index) => Song());

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
                SearchBar(),
                MusicSliver(
                  trackTitle: 'Мои треки',
                  playlists: playlists,
                  songs: songs,
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
