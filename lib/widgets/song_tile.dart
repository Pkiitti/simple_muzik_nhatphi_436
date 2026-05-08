import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/playlist_provider.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(8),
        ),
        // Nếu có ảnh bìa thì hiển thị, không thì hiện icon nốt nhạc
        child: const Icon(Icons.music_note, color: Color(0xFF1DB954)),
      ),
      title: Text(
        song.title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        color: const Color(0xFF282828),
        onSelected: (value) {
          if (value == 'add_to_playlist') {
            _showPlaylistsBottomSheet(context, song);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'add_to_playlist',
            child: Text('Thêm vào Playlist', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  // Hàm hiển thị danh sách Playlist từ dưới vuốt lên
  void _showPlaylistsBottomSheet(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<PlaylistProvider>(
          builder: (context, provider, child) {
            // Trường hợp chưa tạo Playlist nào
            if (provider.playlists.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Bạn chưa có Playlist nào.\nHãy tạo Playlist trước nhé!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              );
            }

            // Hiển thị danh sách các Playlist để người dùng chọn
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chọn Playlist',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = provider.playlists[index];
                      final isAlreadyAdded = playlist.songIds.contains(song.id);

                      return ListTile(
                        leading: const Icon(Icons.queue_music, color: Colors.grey),
                        title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
                        // Nếu bài hát đã có trong Playlist này rồi thì hiện dấu tick xanh
                        trailing: isAlreadyAdded
                            ? const Icon(Icons.check_circle, color: Color(0xFF1DB954))
                            : null,
                        onTap: () {
                          if (!isAlreadyAdded) {
                            provider.addSongToPlaylist(playlist.id, song.id);
                            Navigator.pop(context); // Đóng bảng chọn
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã thêm vào ${playlist.name}')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bài hát đã có trong ${playlist.name} rồi!')),
                            );
                          }
                        },
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
  }
}