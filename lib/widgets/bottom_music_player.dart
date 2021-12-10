part of 'music_player.dart';

class BottomMusicPlayer extends StatefulWidget {
  const BottomMusicPlayer({
    Key? key,
    required this.opacityNotifier,
  }) : super(key: key);

  final ValueNotifier<double> opacityNotifier;

  @override
  State<BottomMusicPlayer> createState() => _BottomMusicPlayerState();
}

class _BottomMusicPlayerState extends State<BottomMusicPlayer>
    with TickerProviderStateMixin {
  // late int _waveDuration;
  // late CurvedAnimation _waveCurve;
  // late Animation<double> _waveHeightPercentage;

  @override
  void initState() {
    super.initState();
    // _waveDuration = 3000;
    // GlobalParameters.waveController = GlobalParameters.waveController ??
    //     AnimationController(
    //       vsync: this,
    //       duration: Duration(milliseconds: _waveDuration),
    //     );
    // _waveCurve = CurvedAnimation(
    //   parent: GlobalParameters.waveController!,
    //   curve: Curves.easeInOut,
    // );
    // _waveHeightPercentage = Tween(
    //   begin: 0.75,
    //   end: 0.45,
    // ).animate(
    //   _waveCurve,
    // );

    // GlobalParameters.playAnimationController =
    //     GlobalParameters.playAnimationController ??
    //         AnimationController(
    //           vsync: this,
    //           duration: Duration(milliseconds: 500),
    //         );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: widget.opacityNotifier,
        builder: (context, double percent, child) {
          return Opacity(
            opacity: percent,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  GlobalParameters.snappingSheetController
                      .snapToPosition(ConstantData.snappingPositions[1]);
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Stack(
                    children: [
                      // PlayerWave(
                      //   config: CustomConfig(
                      //     // There is an error
                      //     gradients: [
                      //       [
                      //         Theme.of(context).splashColor,
                      //         Theme.of(context).splashColor.withOpacity(0.0),
                      //       ],
                      //     ],
                      //     durations: [10000],
                      //     heightPercentages: [_waveHeightPercentage],
                      //     blur: MaskFilter.blur(BlurStyle.solid, 5),
                      //     gradientBegin: Alignment.bottomCenter,
                      //     gradientEnd: Alignment.topCenter,
                      //   ),
                      //   waveAmplitude: 0,
                      //   backgroundColor: Colors.transparent,
                      //   size: Size(
                      //       double.infinity, ConstantData.bottomPlayerHeight),
                      // ),
                      Container(
                        width: double.infinity,
                        height: ConstantData.bottomPlayerHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.7,
                              child: ValueListenableBuilder(
                                  valueListenable: GlobalParameters.currentSong,
                                  builder: (context, value, child) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          GlobalParameters
                                                  .currentSong.value.title ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          GlobalParameters.currentSong.value
                                                      .title !=
                                                  null
                                              ? GlobalParameters.currentSong.value.artists.sublist(1).fold<String>(GlobalParameters.currentSong.value.artists.first.name!, (prev, next) => prev += ', ' + next.name!)
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            const Spacer(),
                            // TODO: place button on the center of songs' duration
                            // IconButton(
                            //   color: Theme.of(context).focusColor,
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 0),
                            //   splashRadius: 20,
                            //   icon: ValueListenableBuilder(
                            //     valueListenable: GlobalParameters.playNotifier,
                            //     builder: (context, value, __) {
                            //       return AnimatedIcon(
                            //         icon: AnimatedIcons.play_pause,
                            //         size: 30,
                            //         progress: GlobalParameters
                            //             .playAnimationController!,
                            //         color: Theme.of(context).focusColor,
                            //       );
                            //     },
                            //   ),
                            //   onPressed: () {
                            //     GlobalParameters.playPauseSong();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
