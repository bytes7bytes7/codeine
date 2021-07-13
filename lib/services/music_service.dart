import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:codeine/models/artist.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/services/bytes_service.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/user.dart';
import '../global/global_parameters.dart';
import '../services/win1251_decoder.dart';
import '../constants.dart';

abstract class MusicService {
  static Future<MusicStatus> getAllMusic() async {
    if (User.id != null) {
      Response response;
      try {
        response = await User.dio.get(
          '${ConstantHTTP.vkMusicURL}${User.id}',
          queryParameters: {'section': 'all'},
          options:
              Options(responseType: ResponseType.bytes, followRedirects: true),
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
        startString:
            '<div class=\'CatalogSection__leftColumn CatalogSection__paginatedBlocks',
        endString: '<div class=\'CatalogSection__rightColumn',
      );

      List<String> songDivs = BytesService.splitByte(
        data: data,
        splitString: 'tabindex=',
      );
      songDivs.removeAt(0);

      List<Song> songs = <Song>[];
      for (var div in songDivs) {
        String dataAudio = BytesService.subByte(
          data: div,
          startString: 'data-audio="',
          endString: ']"',
          cutStart: true,
        );
        dataAudio += utf8.encode(']')[0].toString() + ', ';
        List<int> bytes = BytesService.getInts(dataAudio);
        // Convert windows1251 bytes to string
        dataAudio = Win1251Decoder.decode(bytes);
        var unescape = HtmlUnescape();
        dataAudio =
            dataAudio.replaceAll('&quot;', '\"').replaceAll('&amp;', '&');
        var jsonData = json.decode(dataAudio);
        Song newSong = Song();
        newSong.id = jsonData[0];
        newSong.title = unescape.convert(jsonData[3]);
        newSong.artists = jsonData[4]
            .split(',')
            .map<Artist>((n) => Artist(name: unescape.convert(n)))
            .toList();
        newSong.seconds = jsonData[5];
        newSong.songImageUrl =
            jsonData[14].split(',').last.replaceAll('&amp;', '&');
        newSong.duration =
            Win1251Decoder.decode(BytesService.getInts(BytesService.subByte(
          data: div,
          startString:
              'audio_row__duration audio_row__duration-s _audio_row__duration">',
          endString: r'</div>',
          cutStart: true,
        )));
        try {
          newSong.albumUrl = jsonData[19].join('_');
        }catch(e){
          //
        }
        songs.add(newSong);
      }
      GlobalParameters.songs.value = songs;
      if (GlobalParameters.currentSong.value.title==null){
        GlobalParameters.currentSong.value = GlobalParameters.songs.value[0];
      }
      return MusicStatus.ok;
    }
    return MusicStatus.error;
  }


}
