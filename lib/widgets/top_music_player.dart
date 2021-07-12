part of 'music_player.dart';

class TopMusicPlayer extends StatefulWidget {
  const TopMusicPlayer({
    Key key,
    @required this.safeHeight,
    @required this.firstSizedBox,
    @required this.firstContainer,
    @required this.secondSizedBox,
    @required this.bigCircleRadius,
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
  AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.75, end: 1);
  PageController pageController;

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
            ),
            SizedBox(height: widget.secondSizedBox),
            Container(
              height: size.width * 0.9,
              child: PageView.builder(
                // TODO: maybe something here causes error: The following _CastError was thrown during a service extension callback for "ext.flutter.inspector.getRootWidgetSummaryTree": Null check operator used on a null value
                controller: pageController,
                itemCount: GlobalParameters.songs.length,
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                onPageChanged: (index) {
                  GlobalParameters.playSongByIndex(index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: widget.bigCircleRadius*2,
                        width: widget.bigCircleRadius*2,
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
                              future: GlobalParameters.songs[index]
                                  .generateColors(),
                              builder: (context, snapshot) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: widget.bigCircleRadius,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: (GlobalParameters
                                            .songs[index]
                                            .albumImageUrl
                                            .isNotEmpty)
                                        ? NetworkImage(GlobalParameters
                                            .songs[index].albumImageUrl)
                                        : (GlobalParameters.songs[index]
                                                .songImageUrl.isNotEmpty)
                                            ? NetworkImage(GlobalParameters
                                                .songs[index].songImageUrl)
                                            : AssetImage('assets/png/cup.png'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: size.width * 0.9,
                        child: Text(
                          GlobalParameters.songs[index].title,
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: size.width * 0.9,
                        child: Text(
                          '${GlobalParameters.songs[index].artists.sublist(1).fold<String>(GlobalParameters.songs[index].artists.first.name, (prev, next) => prev += ', ' + next.name)}',
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20.0,
                right: 20.0,
              ),
              child: FutureBuilder(
                  future: GlobalParameters.currentSong.value.generateColors(),
                  builder: (context, snapshot) {
                    return SongSlider(
                      firstColor: GlobalParameters.currentSong.value.firstColor,
                      secondColor:
                          GlobalParameters.currentSong.value.secondColor,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PlayerControls(
                pageController: pageController,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
