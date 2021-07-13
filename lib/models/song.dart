import 'dart:math';
import 'package:codeine/global/global_parameters.dart';
import 'package:codeine/models/artist.dart';
import 'package:codeine/models/user.dart';
import 'package:codeine/services/bytes_service.dart';
import 'package:codeine/services/win1251_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../constants.dart';

class Song {
  Song({
    this.id,
    this.title,
    this.artists,
    this.duration,
    this.songImageUrl='',
    this.albumImageUrl='',
    this.albumUrl='',
    this.seconds,
  });

  int id;
  String title;
  List<Artist> artists;
  int seconds;
  String duration;
  String songImageUrl;
  String albumImageUrl;
  String albumUrl;
  Color primaryColor;
  Color firstColor;
  Color secondColor;
  final randomInstance = Random();

  Future<void> generateColors() async {
    if(albumImageUrl.isEmpty && title!= null) {
      getAlbumImageUrl();
    }
    if (firstColor == null || secondColor == null) {
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

  Future<void> getAlbumImageUrl() async {
    if (albumUrl != null) {
      Response response;
      try {
        response = await User.dio.get(
          '${ConstantHTTP.vkAlbumUrl}$albumUrl',
          options:
          Options(responseType: ResponseType.bytes, followRedirects: false),
        );
      } on DioError catch (e) {
        if (GlobalParameters.connectionStatus.value ==
            ConnectivityResult.none) {
          return MusicStatus.noInternet;
        } else {
          print('logIn error: ${e.error}');
          print('logIn error: ${e.message}');
          print('logIn error: ${e.type}');
          return MusicStatus.unknownError;
        }
      }

      String data = response.data.toString();

      data = BytesService.subByte(
        data: data,
        startString: 'background-image:url(\'',
        endString: '\');',
        cutStart: true,
      );

      albumImageUrl = Win1251Decoder.decode(BytesService.getInts(data));
    }
  }

  Future<PaletteGenerator> _getPrimaryColor() async {
    PaletteGenerator paletteGenerator;
    if (songImageUrl.isNotEmpty) {
      paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(songImageUrl).image,
      );
    } else {
      paletteGenerator = PaletteGenerator.fromColors(
        List.generate(
          3,
          (index) => PaletteColor(
            Color((randomInstance.nextDouble() * 0xFFFFFF).toInt()),
            randomInstance.nextInt(10000),
          ),
        ),
      );
    }
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
