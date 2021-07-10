part of 'music_player.dart';

class MiddleMusicPlayer extends StatelessWidget {
  MiddleMusicPlayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Icon(
            Icons.arrow_drop_up_outlined,
            color: Theme.of(context).focusColor,
            size: 30.0,
          ),
          SizedBox(height: 15),
          Text(
            GlobalParameters.currentSong.value.title,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 5),
          Text(
            '${GlobalParameters.currentSong.value.artists.sublist(1).fold<String>(GlobalParameters.currentSong.value.artists.first, (prev, next) => prev += ', ' + next)}' +
                ((GlobalParameters.currentSong.value.feat.isNotEmpty)
                    ? ' feat ' +
                    GlobalParameters.currentSong.value.feat
                        .sublist(1)
                        .fold<String>(
                        GlobalParameters.currentSong.value.feat.first,
                            (prev, next) => prev += ', ' + next)
                    : ''),
            style: Theme.of(context).textTheme.bodyText2,
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
            padding: const EdgeInsets.only(top: 10),
            child: SongSlider(
              firstColor: Color(0xFF26FF56),
              secondColor: Color(0xFF2CDEFF),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: GlobalParameters.songSeconds,
            builder: (context, percent, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Song.time(GlobalParameters.songSeconds.value.toInt()),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      GlobalParameters.currentSong.value.duration,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              );
            }
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.fast_rewind_rounded),
                color: Theme.of(context).focusColor,
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.pause_circle_filled_rounded),
                color: Theme.of(context).focusColor,
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.fast_forward_rounded),
                color: Theme.of(context).focusColor,
                iconSize: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
