part of 'music_player.dart';

class PlayerControls extends StatelessWidget {
  PlayerControls({
    Key key,
    this.pageController,
  });

  final PageController pageController;
  final Duration duration = Duration(milliseconds: 400);
  final Curve curve = Curves.easeInOut;

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
            if(pageController!=null){
              GlobalParameters.moveToPreviousIndex();
              pageController.animateToPage(GlobalParameters.songNumber, duration: duration, curve: curve);
            }else {
              GlobalParameters.previousSong();
            }
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
            if(pageController!=null){
              GlobalParameters.moveToNextIndex();
              pageController.animateToPage(GlobalParameters.songNumber, duration: duration, curve: curve);
            }else {
              GlobalParameters.nextSong();
            }
          },
        ),
      ],
    );
  }
}
