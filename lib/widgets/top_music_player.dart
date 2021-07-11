part of 'music_player.dart';

class TopMusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: size.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  color: Theme.of(context).focusColor,
                  iconSize: 30.0,
                  onPressed: () {
                    GlobalParameters.snappingSheetController
                        .snapToPosition(ConstantData.snappingPositions[0]);
                  },
                ),
                Text(
                  'CODEINE',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 25),
                ),
                IconButton(
                  icon: Icon(Icons.scatter_plot),
                  color: Theme.of(context).focusColor,
                  iconSize: 30.0,
                  onPressed: () {},
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              radius: 125.5,
              backgroundColor: Theme.of(context).focusColor.withOpacity(0.25),
              child: CircleAvatar(
                radius: 107.5,
                backgroundImage:
                    NetworkImage(GlobalParameters.currentSong.value.imageUrl),
              ),
            ),
            SizedBox(height: 30),
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
            Spacer(),
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
              child: FutureBuilder(
                future: GlobalParameters.currentSong.value.generateColors(),
                builder: (context, snapshot) {
                  return SongSlider(
                    firstColor: GlobalParameters.currentSong.value.firstColor,
                    secondColor: GlobalParameters.currentSong.value.secondColor,
                  );
                }
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
                }),
            SizedBox(height: 10),
            PlayerControls(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}