import 'dart:async';
import 'package:codeine/models/playlist.dart';
import 'package:codeine/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

abstract class GlobalParameters {
  // Private
  static final Connectivity _connectivity = Connectivity();
  static final StreamSubscription<ConnectivityResult>
      _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen((result) {
    connectionStatus.value = result;
  });

  // Public
  static final ValueNotifier<ConnectivityResult> connectionStatus =
      ValueNotifier(ConnectivityResult.none);
  static final ValueNotifier<String> currentPage =
      ValueNotifier('SplashScreen');

  static List<Playlist> playlists = List.generate(5, (index) => Playlist());
  static List<Song> songs = <Song>[
    Song(
      id: 0,
      title: 'Betrayed',
      artists: ['Lil Xan'],
      feat: [],
      duration: '3:07',
      imageUrl:
          'https://sun2-12.userapi.com/impf/c858328/v858328801/fa147/_QSE1Uz9MxA.jpg?size=592x592&quality=96&sign=b947a9c2f93af37a8b161071fe00109d&type=audio',
    ),
    Song(
      id: 1,
      title: 'Figure It Out',
      artists: ['Blu DeTiger'],
      feat: [],
      duration: '2:44',
      imageUrl:
          'https://sun2-4.userapi.com/impf/c858220/v858220100/23d5f9/oFmETPMfPWo.jpg?size=592x592&quality=96&sign=a8f3dd0c296e794dc395204a3fb84c90&type=audio',
    ),
    Song(
      id: 2,
      title: 'Broccoli (feat. Lil Yachty)',
      artists: ['Shelley FKA DRAM'],
      feat: ['Lil Yachty'],
      duration: '3:45',
      imageUrl:
          'https://sun2-3.userapi.com/impf/c857632/v857632634/42976/g6UFFRU2X4s.jpg?size=592x592&quality=96&sign=50f681a1964bb7cc8049dd7db53578e8&type=audio',
    ),
    Song(
      id: 3,
      title: 'Dragonborn',
      artists: ['Big Baby Tape'],
      feat: [],
      duration: '3:09',
      imageUrl:
          'https://sun2-10.userapi.com/impf/c849228/v849228340/c2dd5/0KZPjgB-zt0.jpg?size=592x592&quality=96&sign=ce2dc2db9e841a07b403f0d691772eb0&type=audio',
    ),
    Song(
      id: 4,
      title: 'Привычка',
      artists: ['Скриптонит'],
      feat: ['Andy Panda', '104'],
      duration: '3:16',
      imageUrl:
          'https://sun2-9.userapi.com/impf/NS7bO5bXFp3l1B1HdI_tQSyFKr4YLPen4rnU5Q/2kYTNB5ljmg.jpg?size=592x592&quality=96&sign=40e1fa138ed05380cb6fed3d2a0c1749&type=audio',
    ),
    Song(
      id: 5,
      title: 'Rain (from Suicide Squad)',
      artists: ['grandson', 'Jessie Reyez'],
      feat: [],
      duration: '3:56',
      imageUrl:
          'https://sun2-12.userapi.com/impf/uTcGjQn135E_3iRwF2yiL7S5YmqJp9hzGz5O_A/zbQVtydXD3Q.jpg?size=592x592&quality=96&sign=312b342b4f52c5badbb61edbfe1ec119&type=audio',
    ),
    Song(
      id: 6,
      title: 'Batman',
      artists: ['LPB Poody'],
      feat: [],
      duration: '2:36',
      imageUrl:
          'https://sun2-4.userapi.com/impf/c857332/v857332204/188aa2/6FfPjj7ZGjY.jpg?size=592x592&quality=96&sign=c82ecefc9400c91941b97b8ef8835e8f&type=audio',
    ),
    Song(
      id: 7,
      title: 'Drip or Drown',
      artists: ['Gunna'],
      feat: [],
      duration: '2:06',
      imageUrl:
          'https://sun2-11.userapi.com/impf/c858032/v858032821/4a222/sxDplVHIfl8.jpg?size=592x592&quality=96&sign=978c7a7e88cbe024ac524599d3c10b52&type=audio',
    ),
  ];

  static final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  static AnimationController playAnimationController;
  static AnimationController waveController;
  static final ValueNotifier<bool> playNotifier = ValueNotifier(false);
  static final ValueNotifier<Song> currentSong = ValueNotifier(songs[0]);
  static int songId = songs[0].id;
  static final ValueNotifier<double> songSeconds = ValueNotifier(0.0);
  static final ValueNotifier<bool> shuffleMode = ValueNotifier(false);
  static final ValueNotifier<bool> repeatOneMode = ValueNotifier(false);

  static void playPauseSong() {
    if (playNotifier.value) {
      playNotifier.value = false;
      playAnimationController.reverse();
      waveController.reverse();
    } else {
      playNotifier.value = true;
      playAnimationController.forward();
      waveController.forward();
    }
  }

  static void playSongByID(int id) async {
    songId = id;
    await songs[songId].generateColors();
    currentSong.value = songs[songId];
    songSeconds.value = 0;
  }

  static void previousSong() async {
    if (songs.length > 0) {
      if (songId != 0) {
        songId--;
      } else {
        songId = songs.length - 1;
      }
      await songs[songId].generateColors();
      currentSong.value = songs[songId];
      songSeconds.value = 0;
    }
  }

  static void nextSong() async {
    if (songs.length > 0) {
      if (songId != songs.length - 1) {
        songId++;
      } else {
        songId = 0;
      }
      await songs[songId].generateColors();
      currentSong.value = songs[songId];
      songSeconds.value = 0;
    }
  }

  static Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('initConnectivity error: ${e.toString()}');
      return;
    }
    connectionStatus.value = result;
  }

  static void disposeConnectivitySubscription() {
    _connectivitySubscription.cancel();
  }
}
