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

  static List<Playlist> playlists = List.generate(5, (index) => Playlist(
    albumId: '',
    albumName: 'Album',
    ownerName: 'Owner',
    imageUrl: 'https://sun2-4.userapi.com/impf/hIDkjrOOuRcOOIq3sXgVrzZvnNMM3-dSuZK0fQ/DngYeyLGA-I.jpg?size=592x592&quality=96&sign=46e34cc9d064ba391aba77bd56687004&type=audio',
  ));
  static ValueNotifier<List<Song>> songs = ValueNotifier(<Song>[]);

  static final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  static AnimationController? playAnimationController;
  static  AnimationController? waveController;
  static late AnimationController circleController;
  static late AnimationController radiusController;
  static final ValueNotifier<bool> playNotifier = ValueNotifier(false);
  static final ValueNotifier<Song> currentSong = ValueNotifier(songs.value.isNotEmpty ? songs.value[0] : Song(
    id: '',
    artists: [],
    duration: '0',
    seconds: 0,
  ));
  static int songNumber = 0;
  static final ValueNotifier<double> songSeconds = ValueNotifier(0.0);
  static final ValueNotifier<bool> shuffleMode = ValueNotifier(false);
  static final ValueNotifier<bool> repeatOneMode = ValueNotifier(false);

  static void playPauseSong() {
    if(playAnimationController != null && waveController != null) {
      if (playNotifier.value) {
        playNotifier.value = false;
        playAnimationController!.reverse();
        waveController!.reverse();
        radiusController.reverse();
      } else {
        playNotifier.value = true;
        playAnimationController!.forward();
        waveController!.forward();
        radiusController.forward();
      }
    }
  }

  static void playSongByID(String id) async {
    songNumber = songs.value.indexWhere((s) => s.id == id);
    Song nextSong = songs.value[songNumber];
    await nextSong.generateColors();
    currentSong.value = nextSong;
    songSeconds.value = 0;
  }

  static void playSongByIndex(int index) async {
    songNumber = index;
    Song nextSong = songs.value[songNumber];
    await nextSong.generateColors();
    currentSong.value = nextSong;
    songSeconds.value = 0;
  }

  static void moveToPreviousIndex() {
    if (songNumber != 0) {
      songNumber--;
    } else {
      songNumber = songs.value.length - 1;
    }
  }

  static void previousSong() async {
    if (songs.value.isNotEmpty) {
      moveToPreviousIndex();
      Song song = songs.value[songNumber];
      await song.generateColors();
      currentSong.value = song;
      songSeconds.value = 0;
    }
  }

  static void moveToNextIndex() {
    if (songNumber != songs.value.length - 1) {
      songNumber++;
    } else {
      songNumber = 0;
    }
  }

  static void nextSong() async {
    if (songs.value.isNotEmpty) {
      moveToNextIndex();
      Song song = songs.value[songNumber];
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
      // ignore: avoid_print
      print('initConnectivity error: ${e.toString()}');
      return;
    }
    connectionStatus.value = result;
  }

  static void disposeConnectivitySubscription() {
    _connectivitySubscription.cancel();
  }
}
