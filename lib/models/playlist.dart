import 'package:codeine/models/song.dart';

class Playlist {
  Playlist({
    required this.albumId,
    this.ownerId,
    required this.albumName,
    required this.ownerName,
    required this.imageUrl,
    this.genre,
    this.year,
    this.auditions,
    this.numberOfSongs,
    this.albumSeconds,
    this.songs,
  });

  String albumId;
  int? ownerId;
  String albumName;
  String ownerName;
  String imageUrl;
  String? genre;
  int? year;
  String? auditions;
  int? numberOfSongs;
  int? albumSeconds;
  List<Song>? songs;
}
