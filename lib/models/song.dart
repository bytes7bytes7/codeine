import 'dart:math';

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

  double seconds() {
    List<int> lst = duration
        .split(':')
        .map<int>((e) => int.parse(e))
        .toList()
        .reversed
        .toList();
    double seconds = 0;
    for (int i = 0; i < lst.length; i++) {
      seconds += pow(60, i) * lst[i];
    }
    return seconds;
  }

  static String time(int seconds) {
    List<String> lst = [];
    while (seconds >= 60) {
      lst.add((seconds ~/ 60).toString());
      seconds -= int.parse(lst.last) * 60;
    }
    lst.add(seconds.toString());
    if(lst.length==1){
      lst.add('0');
      lst = lst.reversed.toList();
    }
    for (int i = 1; i < lst.length; i++) {
      if (lst[i].length < 2) {
        lst[i] = '0' + lst[i];
      }
    }
    return lst.join(':');
  }
}
