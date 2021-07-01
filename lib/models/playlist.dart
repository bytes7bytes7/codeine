class Playlist {
  Playlist({
    this.albumId,
    this.ownerId,
    this.albumName = 'Life Sucks asd sad  as',
    this.ownerName = 'Lil Xan',
    this.imageUrl = 'https://sun2-3.userapi.com/impf/7hFBQU8uAs3CuvqCfNl9eeDqTmFfDvGg-HoVsw/3O5gbuRquFU.jpg?size=300x300&quality=96&sign=7f98fc2169d23eb95e94020d2c17968e&type=audio',
  });

  int albumId;
  int ownerId;
  String albumName;
  String ownerName;
  String imageUrl;
}