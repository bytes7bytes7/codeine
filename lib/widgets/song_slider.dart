part of 'music_player.dart';


class SongSlider extends StatelessWidget {
  const SongSlider({
    Key? key,
    required this.firstColor,
    required this.secondColor,
  }) : super(key: key);

  final Color firstColor;
  final Color secondColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.songSeconds,
      builder: (context, double value, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: GradientRectSliderTrackShape(
              firstColor: firstColor,
              secondColor: secondColor,
            ),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            // TODO: doesn't work
            overlayColor: firstColor.withOpacity(0.25),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: GlobalParameters.currentSong.value.title != null ? GlobalParameters.currentSong.value.seconds.toDouble() : 0.0,
            onChanged: (newValue) {
              GlobalParameters.songSeconds.value = newValue;
            },
            activeColor: Theme.of(context).focusColor,
          ),
        );
      },
    );
  }
}
