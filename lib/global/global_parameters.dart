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
  static List<Song> songs = <Song>[];

  static final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  static AnimationController playAnimationController;
  static AnimationController waveController;
  static AnimationController circleController;
  static PageController musicPageController = PageController();
  static final ValueNotifier<bool> playNotifier = ValueNotifier(false);
  static final ValueNotifier<Song> currentSong = ValueNotifier(songs[0]);
  static int songNumber = 0;
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
    songNumber = songs.indexWhere((s) => s.id == id);
    Song nextSong = songs[songNumber];
    await nextSong.generateColors();
    currentSong.value = nextSong;
    songSeconds.value = 0;
  }

  static void playSongByIndex(int index) async {
    songNumber = index;
    Song nextSong = songs[songNumber];
    await nextSong.generateColors();
    currentSong.value = nextSong;
    songSeconds.value = 0;
  }

  static void previousSong() async {
    if (songs.length > 0) {
      int index = songs.indexOf(currentSong.value);
      if (index != 0) {
        index--;
      } else {
        index = songs.length - 1;
      }
      Song song = songs[index];
      songNumber = index;
      await song.generateColors();
      currentSong.value = song;
      songSeconds.value = 0;
    }
  }

  static void nextSong() async {
    if (songs.length > 0) {
      int index = songs.indexOf(currentSong.value);
      if (index != songs.length - 1) {
        index++;
      } else {
        index = 0;
      }
      Song song = songs[index];
      songNumber = index;
      await song.generateColors();
      currentSong.value = song;
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
