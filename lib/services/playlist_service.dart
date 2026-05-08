import 'package:on_audio_query/on_audio_query.dart' as q;
import '../models/song_model.dart';

class PlaylistService {
  final q.OnAudioQuery _audioQuery = q.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    try {
      final List<q.SongModel> audioList = await _audioQuery.querySongs(
        sortType: q.SongSortType.TITLE,
        orderType: q.OrderType.ASC_OR_SMALLER,
        uriType: q.UriType.EXTERNAL,
        ignoreCase: true,
      );
      return audioList.map((audio) => SongModel.fromAudioQuery(audio)).toList();
    } catch (e) {
      throw Exception('Error loading songs: $e');
    }
  }

  Future<List<SongModel>> getSongsByArtist(String artist) async {
    final allSongs = await getAllSongs();
    return allSongs.where((song) => song.artist == artist).toList();
  }

  Future<List<SongModel>> getSongsByAlbum(String album) async {
    final allSongs = await getAllSongs();
    return allSongs.where((song) => song.album == album).toList();
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final allSongs = await getAllSongs();
    final lowerQuery = query.toLowerCase();
    return allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery) ||
          (song.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}