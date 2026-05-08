import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../models/song_model.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  Duration get currentPosition => _audioPlayer.position;
  Duration? get currentDuration => _audioPlayer.duration;
  bool get isPlaying => _audioPlayer.playing;

  Stream<PlaybackState> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, PlaybackState>(
      positionStream,
      durationStream,
      playingStream,
          (position, duration, isPlaying) => PlaybackState(
        position: position,
        duration: duration ?? Duration.zero,
        isPlaying: isPlaying,
      ),
    );
  }

  Future<void> loadAudio(SongModel song) async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(song.filePath),
          tag: MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            album: song.album ?? 'Unknown Album',
          ),
        ),
      );
    } catch (e) {
      throw Exception('Error loading audio: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    await _audioPlayer.setLoopMode(loopMode);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class PlaybackState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  PlaybackState({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  double get progress {
    if (duration.inMilliseconds > 0) {
      return position.inMilliseconds / duration.inMilliseconds;
    }
    return 0.0;
  }
}