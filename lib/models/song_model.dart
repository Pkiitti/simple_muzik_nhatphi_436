class SongModel {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String filePath;
  final Duration? duration;
  final String? albumArt;
  final int? fileSize;
  final int? dateAdded;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.filePath,
    this.duration,
    this.albumArt,
    this.fileSize,
    this.dateAdded,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      filePath: json['filePath'],
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : null,
      albumArt: json['albumArt'],
      fileSize: json['fileSize'],
      dateAdded: json['dateAdded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'duration': duration?.inMilliseconds,
      'albumArt': albumArt,
      'fileSize': fileSize,
      'dateAdded': dateAdded,
    };
  }

  factory SongModel.fromAudioQuery(dynamic audioModel) {
    return SongModel(
      id: audioModel.id.toString(),
      title: audioModel.title,
      artist: audioModel.artist ?? 'Unknown Artist',
      album: audioModel.album,
      filePath: audioModel.data,
      duration: Duration(milliseconds: audioModel.duration ?? 0),
      dateAdded: audioModel.dateAdded,
    );
  }
}