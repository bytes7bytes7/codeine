import 'package:codeine/models/playlist.dart';
import 'package:flutter/material.dart';
import 'thin_text_button.dart';

class PlaylistList extends StatelessWidget {
  const PlaylistList({
    Key key,
    @required this.playlists,
  }) : super(key: key);

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Плейлисты',
                style: Theme.of(context).textTheme.headline3,
              ),
              ThinTextButton(
                text: 'Все',
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: playlists.length + 2,
            itemBuilder: (context, index) {
              if (index == 0 || index == playlists.length + 1) {
                return SizedBox(width: 22.0);
              } else {
                return PlaylistCard(playlist: playlists[index - 1]);
              }
            },
          ),
        ),
      ],
    );
  }
}

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    Key key,
    @required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 132.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 124,
                width: 124,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      playlist.imageUrl,
                    ),
                  ),
                ),
              ),
              Text(
                playlist.albumName,
                style: Theme.of(context).textTheme.bodyText2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                playlist.ownerName,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
