import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/playlist_provider.dart';
import '../providers/audio_provider.dart';
import '../services/playlist_service.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlaylistService _playlistService = PlaylistService();
  List<SongModel> _allSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllSongs();
  }

  Future<void> _loadAllSongs() async {
    final songs = await _playlistService.getAllSongs();
    setState(() {
      _allSongs = songs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, provider, child) {
        final playlistIndex = provider.playlists.indexWhere((p) => p.id == widget.playlistId);
        if (playlistIndex == -1) return const Scaffold(backgroundColor: Color(0xFF191414));

        final playlist = provider.playlists[playlistIndex];
        final playlistSongs = _allSongs.where((song) => playlist.songIds.contains(song.id)).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF191414),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(playlist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1DB954), size: 28),
                onPressed: () => _showAddSongsBottomSheet(context, widget.playlistId),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : playlistSongs.isEmpty
              ? const Center(
            child: Text(
              'Playlist này đang trống.\nBấm dấu + ở góc trên để thêm nhạc nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
              : ListView.builder(
            itemCount: playlistSongs.length,
            itemBuilder: (context, index) {
              final song = playlistSongs[index];
              return ListTile(
                leading: const Icon(Icons.music_note, color: Colors.grey),
                title: Text(
                  song.title,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  onPressed: () {
                    provider.removeSongFromPlaylist(playlist.id, song.id);
                  },
                ),
                onTap: () {
                  context.read<AudioProvider>().setPlaylist(playlistSongs, index);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showAddSongsBottomSheet(BuildContext context, String playlistId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<PlaylistProvider>(
              builder: (context, provider, child) {
                final playlistIndex = provider.playlists.indexWhere((p) => p.id == playlistId);
                if (playlistIndex == -1) return const SizedBox.shrink();
                final currentPlaylist = provider.playlists[playlistIndex];

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Thêm bài hát', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _allSongs.length,
                        itemBuilder: (context, index) {
                          final song = _allSongs[index];
                          final isAdded = currentPlaylist.songIds.contains(song.id);
                          return ListTile(
                            leading: const Icon(Icons.music_note, color: Colors.grey),
                            title: Text(song.title, style: const TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(song.artist, style: const TextStyle(color: Colors.grey)),
                            trailing: isAdded
                                ? const Icon(Icons.check_circle, color: Color(0xFF1DB954))
                                : IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                              onPressed: () {
                                provider.addSongToPlaylist(currentPlaylist.id, song.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}