import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../services/audio_player_service.dart';
import '../widgets/progress_bar.dart';
import '../widgets/player_controls.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;
          if (song == null) {
            return const Center(child: Text('No song playing', style: TextStyle(color: Colors.white)));
          }
          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, provider),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAlbumArt(song),
                        const SizedBox(height: 30),
                        _buildSongInfo(song),
                        const SizedBox(height: 20),

                        // Đã truyền biến context vào đây
                        _buildVolumeSlider(context, provider),
                        const SizedBox(height: 10),

                        StreamBuilder<PlaybackState>(
                          stream: provider.playbackStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            return ProgressBar(
                              position: state?.position ?? Duration.zero,
                              duration: state?.duration ?? Duration.zero,
                              onSeek: (position) {
                                provider.seek(position);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        PlayerControls(provider: provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AudioProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          PopupMenuButton<double>(
            icon: const Icon(Icons.speed, color: Colors.white),
            color: const Color(0xFF282828),
            onSelected: (speed) {
              provider.setSpeed(speed);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0.5, child: Text('0.5x (Chậm)', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 1.0, child: Text('1.0x (Bình thường)', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 1.5, child: Text('1.5x (Nhanh)', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 2.0, child: Text('2.0x (Rất nhanh)', style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }

  // Đã cập nhật lại hàm này để nhận BuildContext
  Widget _buildVolumeSlider(BuildContext context, AudioProvider provider) {
    return Row(
      children: [
        const Icon(Icons.volume_down, color: Colors.grey),
        Expanded(
          child: SliderTheme(
            // Gọi context trực tiếp ở đây
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF1DB954),
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: Colors.white,
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            ),
            child: Slider(
              value: provider.volume,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                provider.setVolume(value);
              },
            ),
          ),
        ),
        const Icon(Icons.volume_up, color: Colors.grey),
      ],
    );
  }

  Widget _buildAlbumArt(SongModel song) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.albumArt != null
            ? Image.file(File(song.albumArt!), fit: BoxFit.cover)
            : Container(
          color: const Color(0xFF282828),
          child: const Icon(Icons.music_note, size: 100, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}