import 'package:codeine/models/playlist.dart';
import 'package:codeine/models/song.dart';
import 'package:flutter/material.dart';

import 'playlist_list.dart';
import 'song_card.dart';
import 'thin_text_button.dart';

class MusicSliver extends StatelessWidget {
  const MusicSliver({
    Key key,
    this.trackTitle = 'Треки',
    @required this.songs,
    @required this.playlists,
  }) : super(key: key);

  final String trackTitle;
  final List<Song> songs;
  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return PlaylistList(playlists: playlists);
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trackTitle,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  ThinTextButton(
                    text: 'Порядок',
                    onTap: () {},
                  ),
                ],
              ),
            );
          } else {
            return SongCard(
              song: songs[index - 2],
            );
          }
        },
        childCount: songs.length + 2,
      ),
    );
  }
}
