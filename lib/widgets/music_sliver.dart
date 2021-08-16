import 'package:codeine/constants.dart';
import 'package:codeine/global/global_parameters.dart';
import 'package:flutter/material.dart';

import 'playlist_list.dart';
import 'song_card.dart';
import 'thin_text_button.dart';

class MusicSliver extends StatelessWidget {
  const MusicSliver({
    Key? key,
    required this.goUpAnimation,
    this.trackTitle = 'Треки',
  }) : super(key: key);

  final String trackTitle;
  final Animation goUpAnimation;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.songs,
      builder: (context, _, __) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return PlaylistList(playlists: GlobalParameters.playlists);
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
              } else if (index == GlobalParameters.songs.value.length + 2) {
                return Container(
                  height: ConstantData.bottomPlayerHeight,
                );
              } else {
                return SongCard(
                  song: GlobalParameters.songs.value[index - 2],
                );
              }
            },
            childCount: GlobalParameters.songs.value.length + 3,
          ),
        );
        // AnimatedBuilder(
        //   animation: goUpAnimation,
        //   builder: (context, child){
        //     return Container(
        //       height: 50,
        //       width: 50,
        //       color: Colors.red,
        //     );
        //   },
        // ),
      },
    );
  }
}
