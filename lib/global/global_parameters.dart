import 'dart:async';
import 'package:codeine/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  static final ValueNotifier<Song> currentSong = ValueNotifier(Song());
  static final ValueNotifier<double> songSeconds = ValueNotifier(0.0);

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
