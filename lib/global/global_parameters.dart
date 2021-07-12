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
