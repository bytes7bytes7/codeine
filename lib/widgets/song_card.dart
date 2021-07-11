import 'package:codeine/global/global_parameters.dart';
import 'package:codeine/models/song.dart';
import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key key,
    @required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          GlobalParameters.playSongByID(song.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(19.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          song.imageUrl,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(width: 20),
              Container(
                width: size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${song.artists.sublist(1).fold<String>(song.artists.first, (prev, next) => prev += ', ' + next)}' +
                          ((song.feat.isNotEmpty)
                              ? ' feat ' +
                                  song.feat.sublist(1).fold<String>(
                                      song.feat.first,
                                      (prev, next) => prev += ', ' + next)
                              : ''),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                song.duration,
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
