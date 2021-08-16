part of 'music_player.dart';

class PlayerControls extends StatelessWidget {
  PlayerControls({
    Key? key,
    this.pageController,
  }): super(key:key);

  final PageController? pageController;
  final Duration duration = const Duration(milliseconds: 400);
  final Curve curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.fast_rewind_rounded),
          color: Theme.of(context).focusColor,
          iconSize: 60,
          onPressed: () {
            if (pageController != null) {
              int prevIndex = GlobalParameters.songNumber;
              GlobalParameters.moveToPreviousIndex();
              int nextIndex = GlobalParameters.songNumber;
              if (( nextIndex-prevIndex).abs()==1) {
                pageController!.animateToPage(GlobalParameters.songNumber,
                    duration: duration, curve: curve);
              }else{
                pageController!.jumpToPage(GlobalParameters.songNumber);
              }
            } else {
              GlobalParameters.previousSong();
            }
          },
        ),
        ValueListenableBuilder(
          valueListenable: GlobalParameters.playNotifier,
          builder: (context, value, child) {
            return IconButton(
              icon: (GlobalParameters.playNotifier.value)
                  ? const Icon(Icons.pause_circle_filled_rounded)
                  : const Icon(Icons.play_circle_fill_rounded),
              color: Theme.of(context).focusColor,
              iconSize: 60,
              onPressed: () {
                GlobalParameters.playPauseSong();
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.fast_forward_rounded),
          color: Theme.of(context).focusColor,
          iconSize: 60,
          onPressed: () {
            if (pageController != null) {
              int prevIndex = GlobalParameters.songNumber;
              GlobalParameters.moveToNextIndex();
              int nextIndex = GlobalParameters.songNumber;
              if((nextIndex-prevIndex).abs()==1) {
                pageController!.animateToPage(GlobalParameters.songNumber,
                    duration: duration, curve: curve);
              }else{
                pageController!.jumpToPage(GlobalParameters.songNumber);
              }
            } else {
              GlobalParameters.nextSong();
            }
          },
        ),
      ],
    );
  }
}
