part of 'music_player.dart';

class MiddleMusicPlayer extends StatefulWidget {
  MiddleMusicPlayer({
    Key key,
  }) : super(key: key);

  @override
  State<MiddleMusicPlayer> createState() => _MiddleMusicPlayerState();
}

class _MiddleMusicPlayerState extends State<MiddleMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_drop_up_outlined),
            color: Theme.of(context).focusColor,
            iconSize: 30.0,
            onPressed: () {
              GlobalParameters.snappingSheetController
                  .snapToPosition(ConstantData.snappingPositions[2]);
            },
          ),
          SizedBox(height: 5),
          Container(
            width: size.width*0.8,
            child: Text(
              GlobalParameters.currentSong.value.title,
              style: Theme.of(context).textTheme.headline3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: size.width*0.8,
            child: Text(
              '${GlobalParameters.currentSong.value.artists.sublist(1).fold<String>(GlobalParameters.currentSong.value.artists.first.name, (prev, next) => prev += ', ' + next.name)}',
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: GlobalParameters.shuffleMode,
                builder: (context, value, child) {
                  return IconButton(
                    icon: (value)
                        ? Icon(Icons.shuffle_on_outlined)
                        : Icon(Icons.shuffle_outlined),
                    color: Theme.of(context).focusColor,
                    iconSize: 30,
                    onPressed: () {
                      GlobalParameters.shuffleMode.value =
                          !GlobalParameters.shuffleMode.value;
                    },
                  );
                },
              ),
              Spacer(),
              ValueListenableBuilder(
                valueListenable: GlobalParameters.repeatOneMode,
                builder: (context, value, child) {
                  return IconButton(
                    icon: (value)
                        ? Icon(Icons.repeat_one_on_outlined)
                        : Icon(Icons.repeat_one_outlined),
                    color: Theme.of(context).focusColor,
                    iconSize: 30,
                    onPressed: () {
                      GlobalParameters.repeatOneMode.value =
                          !GlobalParameters.repeatOneMode.value;
                    },
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ValueListenableBuilder(
                valueListenable: GlobalParameters.currentSong,
                builder: (context, value, child) {
                  return SongSlider(
                    firstColor: GlobalParameters.currentSong.value.firstColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    secondColor:
                        GlobalParameters.currentSong.value.secondColor ??
                            Theme.of(context).scaffoldBackgroundColor,
                  );
                }),
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
              }),
          SizedBox(height: 5),
          PlayerControls(),
        ],
      ),
    );
  }
}
