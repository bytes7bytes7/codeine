part of 'music_player.dart';

class BottomMusicPlayer extends StatefulWidget {
  const BottomMusicPlayer({
    Key key,
    @required this.opacityNotifier,
  }) : super(key: key);

  final ValueNotifier<double> opacityNotifier;

  @override
  State<BottomMusicPlayer> createState() => _BottomMusicPlayerState();
}

class _BottomMusicPlayerState extends State<BottomMusicPlayer>
    with TickerProviderStateMixin {
  AnimationController _playAnimationController;
  int _waveDuration;
  AnimationController waveController;
  CurvedAnimation _waveCurve;
  Animation<double> _waveHeightPercentage;

  @override
  void initState() {
    super.initState();
    _waveDuration = 3000;
    waveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _waveDuration),
    );
    _waveCurve = CurvedAnimation(
      parent: waveController,
      curve: Curves.easeInOut,
    );
    _waveHeightPercentage = Tween(
      begin: 0.75,
      end: 0.45,
    ).animate(
      _waveCurve,
    );

    _playAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // TODO: solve problem (when animation is not completed & dispose() is called
    if (!_playAnimationController.isCompleted){
      _playAnimationController.stop();
    }
    _playAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.opacityNotifier,
      builder: (context, percent, child) {
        return Opacity(
          opacity: percent,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                GlobalParameters.snappingSheetController.snapToPosition(ConstantData.snappingPositions[1]);
              },
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    PlayerWave(
                      config: CustomConfig(
                        gradients: [
                          [
                            Theme.of(context).splashColor,
                            Theme.of(context).splashColor.withOpacity(0.0),
                          ],
                        ],
                        durations: [10000],
                        heightPercentages: [_waveHeightPercentage],
                        blur: MaskFilter.blur(BlurStyle.solid, 5),
                        gradientBegin: Alignment.bottomCenter,
                        gradientEnd: Alignment.topCenter,
                      ),
                      waveAmplitude: 0,
                      backgroundColor: Colors.transparent,
                      size: Size(double.infinity, ConstantData.bottomPlayerHeight),
                    ),
                    Container(
                      width: double.infinity,
                      height: ConstantData.bottomPlayerHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: GlobalParameters.currentSong,
                            builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    GlobalParameters.currentSong.value?.title,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${GlobalParameters.currentSong.value.artists.sublist(1).fold<String>(GlobalParameters.currentSong.value.artists.first, (prev, next) => prev += ', ' + next)}' +
                                        ((GlobalParameters.currentSong.value.feat.isNotEmpty)
                                            ? ' feat ' +
                                                GlobalParameters.currentSong.value.feat
                                                    .sublist(1)
                                                    .fold<String>(
                                                        GlobalParameters.currentSong.value.feat.first,
                                                        (prev, next) =>
                                                            prev += ', ' + next)
                                            : ''),
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Theme.of(context).disabledColor,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }
                          ),
                          Spacer(),
                          // TODO: place button on the center of songs' duration
                          IconButton(
                            color: Theme.of(context).focusColor,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            splashRadius: 20,
                            icon: ValueListenableBuilder(
                              valueListenable: GlobalParameters.playNotifier,
                              builder: (context, value, __) {
                                return AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  size: 30,
                                  progress: _playAnimationController,
                                  color: Theme.of(context).focusColor,
                                );
                              },
                            ),
                            onPressed: () {
                              GlobalParameters.playNotifier.value = !GlobalParameters.playNotifier.value;
                              if (GlobalParameters.playNotifier.value) {
                                waveController.forward();
                                _playAnimationController.forward();
                              } else {
                                waveController.reverse();
                                _playAnimationController.reverse();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
