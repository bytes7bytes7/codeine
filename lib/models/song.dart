import 'dart:math';

class Song {
  Song({
    this.id,
    this.title = 'Betrayed',
    this.artists = const ['Lil Xan'],
    this.feat = const [],
    this.duration = '3:07',
    this.imageUrl =
        'https://sun2-12.userapi.com/impf/c858328/v858328801/fa147/_QSE1Uz9MxA.jpg?size=592x592&quality=96&sign=b947a9c2f93af37a8b161071fe00109d&type=audio',
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
