import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:codeine/models/song.dart';
import 'package:codeine/widgets/player_wave.dart';
import 'package:flutter/material.dart';

part 'bottom_music_player.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SnappingSheet(
        child: Container(
          color: Colors.blueGrey,
        ),
        grabbingHeight: 75,
        grabbing: Container(
          width: double.infinity,
          height: 300,
          color: Colors.lightGreen,
        ),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          child: SingleChildScrollView(
            child: Container(
              height: size.height*0.4,
              color: Colors.grey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 30,
                      foregroundColor: Colors.purple,
                    ),
                  ),
                  for (int i = 0; i < 3; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: double.infinity,
                      height: 20,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
