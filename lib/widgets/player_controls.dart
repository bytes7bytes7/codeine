part of 'music_player.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.fast_rewind_rounded),
          color: Theme.of(context).focusColor,
          iconSize: 60,
          onPressed: () {
            GlobalParameters.previousSong();
          },
        ),
        ValueListenableBuilder(
          valueListenable: GlobalParameters.playNotifier,
          builder: (context, value, child) {
            return IconButton(
              icon: (GlobalParameters.playNotifier.value)
                  ? Icon(Icons.pause_circle_filled_rounded)
                  : Icon(Icons.play_circle_fill_rounded),
              color: Theme.of(context).focusColor,
              iconSize: 60,
              onPressed: () {
                GlobalParameters.playPauseSong();
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.fast_forward_rounded),
          color: Theme.of(context).focusColor,
          iconSize: 60,
          onPressed: () {
            GlobalParameters.nextSong();
          },
        ),
      ],
    );
  }
}
