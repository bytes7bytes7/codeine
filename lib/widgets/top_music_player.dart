part of 'music_player.dart';

class TopMusicPlayer extends StatefulWidget {
  const TopMusicPlayer({
    Key? key,
    required this.safeHeight,
    required this.firstSizedBox,
    required this.firstContainer,
    required this.secondSizedBox,
    required this.bigCircleRadius,
  }) : super(key: key);

  final double safeHeight;
  final double firstSizedBox;
  final double firstContainer;
  final double secondSizedBox;
  final double bigCircleRadius;

  @override
  State<TopMusicPlayer> createState() => _TopMusicPlayerState();
}

class _TopMusicPlayerState extends State<TopMusicPlayer>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Tween<double> _tween = Tween(begin: 0.75, end: 1);
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: GlobalParameters.songNumber);
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: widget.safeHeight,
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: widget.firstSizedBox),
            Container(
              height: widget.firstContainer,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
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
                        .headline3!
                        .copyWith(fontSize: 25),
                  ),
                  IconButton(
                    icon: const Icon(Icons.scatter_plot),
                    color: Theme.of(context).focusColor,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            // TODO: finish
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        );
                      }));
                      showMoreBottomSheet(context: context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.secondSizedBox),
            SizedBox(
              height: size.width * 0.9,
              child: PageView.builder(
                // TODO: maybe something here causes error: The following _CastError was thrown during a service extension callback for "ext.flutter.inspector.getRootWidgetSummaryTree": Null check operator used on a null value
                controller: pageController,
                itemCount: GlobalParameters.songs.value.length,
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  GlobalParameters.playSongByIndex(index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: widget.bigCircleRadius * 2,
                        width: widget.bigCircleRadius * 2,
                        child: Stack(
                          children: [
                            // ScaleTransition(
                            //   scale: _tween.animate(
                            //     CurvedAnimation(
                            //         parent: _controller, curve: Curves.elasticOut),
                            //   ),
                            //   child: Container(
                            //     height: 250,
                            //     width: 250,
                            //     child: Container(
                            //       height: 250,
                            //       width: 250,
                            //       decoration: BoxDecoration(
                            //         color: Theme.of(context).focusColor.withOpacity(0.25),
                            //         shape: BoxShape.circle,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            FutureBuilder(
                              future: GlobalParameters.songs.value[index]
                                  .generateColors(),
                              builder: (context, snapshot) {
                                return Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: widget.bigCircleRadius,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: const AssetImage(
                                            'assets/png/cup.png'),
                                      ),
                                    ),
                                    if (GlobalParameters.songs.value[index]
                                        .songImageUrl.isNotEmpty)
                                      Container(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          radius: widget.bigCircleRadius,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              GlobalParameters.songs
                                                  .value[index].songImageUrl),
                                        ),
                                      ),
                                    if (GlobalParameters.songs.value[index]
                                        .albumImageUrl.isNotEmpty)
                                      Container(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          radius: widget.bigCircleRadius,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              GlobalParameters.songs
                                                  .value[index].albumImageUrl),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Text(
                          GlobalParameters.songs.value[index].title ?? '',
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Text(
                          GlobalParameters.songs.value[index].artists
                              .sublist(1)
                              .fold<String>(
                                  GlobalParameters
                                      .songs.value[index].artists.first.name!,
                                  (prev, next) => prev += ', ' + next.name!),
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: GlobalParameters.shuffleMode,
                    builder: (context, bool value, child) {
                      return IconButton(
                        icon: (value)
                            ? const Icon(Icons.shuffle_on_outlined)
                            : const Icon(Icons.shuffle_outlined),
                        color: Theme.of(context).focusColor,
                        iconSize: 30,
                        onPressed: () {
                          GlobalParameters.shuffleMode.value =
                              !GlobalParameters.shuffleMode.value;
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: GlobalParameters.repeatOneMode,
                    builder: (context, bool value, child) {
                      return IconButton(
                        icon: (value)
                            ? const Icon(Icons.repeat_one_on_outlined)
                            : const Icon(Icons.repeat_one_outlined),
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
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20.0,
                right: 20.0,
              ),
              child: FutureBuilder(
                  future: GlobalParameters.currentSong.value.title != null
                      ? GlobalParameters.currentSong.value.generateColors()
                      : Future.delayed(const Duration(milliseconds: 10)),
                  builder: (context, snapshot) {
                    return SongSlider(
                      firstColor:
                          GlobalParameters.currentSong.value.firstColor ??
                              Theme.of(context).scaffoldBackgroundColor,
                      secondColor:
                          GlobalParameters.currentSong.value.secondColor ??
                              Theme.of(context).focusColor,
                    );
                  }),
            ),
            ValueListenableBuilder(
                valueListenable: GlobalParameters.songSeconds,
                builder: (context, percent, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          GlobalParameters.currentSong.value.title != null
                              ? Song.time(
                                  GlobalParameters.songSeconds.value.toInt())
                              : '',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          GlobalParameters.currentSong.value.title != null
                              ? GlobalParameters.currentSong.value.duration
                              : '',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  );
                }),
            const       SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PlayerControls(
                pageController: pageController,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
