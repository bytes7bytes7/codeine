import 'package:codeine/models/artist.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class Song {
  Song(
      {this.id,
      this.title,
      this.artists,
      this.duration,
      this.imageUrl,
      });

  int id;
  String title;
  List<Artist> artists;
  int seconds;
  String duration;
  String imageUrl;
  Color primaryColor;
  Color firstColor;
  Color secondColor;

  Future<void> generateColors() async {
    if(firstColor == null || secondColor == null) {
      PaletteGenerator pg = await _getPrimaryColor();
      primaryColor = pg.paletteColors.first.color;
      firstColor = Color.fromARGB(
          255,
          (primaryColor.red + primaryColor.green + primaryColor.blue).abs() %
              256,
          (primaryColor.green - primaryColor.blue + primaryColor.red) % 256,
          (primaryColor.blue - primaryColor.red + primaryColor.green) % 256);
      secondColor = Color.fromARGB(
          255,
          (primaryColor.red - primaryColor.green + primaryColor.blue) % 256,
          (primaryColor.green - primaryColor.blue + primaryColor.red) % 256,
          (primaryColor.blue - primaryColor.red + primaryColor.green) % 256);
    }
  }

  Future<PaletteGenerator> _getPrimaryColor() async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      Image.network(imageUrl).image,
    );
    return paletteGenerator;
  }

  static String time(int seconds) {
    List<String> lst = [];
    while (seconds >= 60) {
      lst.add((seconds ~/ 60).toString());
      seconds -= int.parse(lst.last) * 60;
    }
    lst.add(seconds.toString());
    if (lst.length == 1) {
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
