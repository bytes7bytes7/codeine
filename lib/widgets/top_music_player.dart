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
                  onPressed: () {},
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
            SizedBox(height: 30),
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
                }),
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
            Spacer(),
          ],
        ),
      ),
    );
  }
}
