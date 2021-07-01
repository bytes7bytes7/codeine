class Song {
  Song({
    this.id,
    this.title = 'Hot (feat. Gunna)',
    this.artists = const ['Young Thug'],
    this.feat = const ['Gunna'],
    this.duration = '3:13',
    this.imageUrl =
        'https://sun9-13.userapi.com/impf/c852036/v852036929/19d6a4/7qLtXSimrjI.jpg?size=80x80&quality=96&sign=207574208226036961a54d5022a1424d&type=audio',
  });

  int id;
  String title;
  List<String> artists;
  List<String> feat;
  String duration;
  String imageUrl;
}
