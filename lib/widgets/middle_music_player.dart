part of 'music_player.dart';

class MiddleMusicPlayer extends StatelessWidget {
  MiddleMusicPlayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 5),
          Text(
            'Lil Xan',
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
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: SongSlider(
              firstColor: Color(0xFF26FF56),
              secondColor: Color(0xFF2CDEFF),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: GlobalParameters.songSeconds,
            builder: (context, percent, child) {
              return Row(
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
              );
            }
          ),
          SizedBox(height: 10),
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