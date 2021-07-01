import 'package:codeine/bloc/bloc.dart';
import 'package:codeine/global/global_parameters.dart';
import 'package:codeine/models/playlist.dart';
import 'package:codeine/models/user.dart';
import 'package:codeine/widgets/playlist_list.dart';
import 'package:codeine/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _Header(),
              SearchBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return PlaylistList(
                        playlists: [
                          Playlist(),
                          Playlist(),
                          Playlist(),
                          Playlist(),
                          Playlist(),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                  childCount: 2,
                ),
              ),
            ],
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
              style: Theme.of(context).textTheme.headline3,
            ),
            Spacer(),
            CircleAvatar(
              radius: Theme.of(context).textTheme.headline3.fontSize / 1.25,
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
