import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song_model.dart';
import '../services/playlist_service.dart';
import '../services/permission_service.dart';
import '../providers/audio_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import 'playlists_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final PermissionService _permissionService = PermissionService();
  List<SongModel> _songs = [];
  List<SongModel> _allSongs = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _hasPermission = await _permissionService.requestSmartPermission();

    if (_hasPermission) {
      await _loadSongs();
    }

    if (mounted) {
      setState(() {
        if (_songs.isNotEmpty) _hasPermission = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSongs() async {
    try {
      final songs = await _playlistService.getAllSongs();
      setState(() {
        _songs = songs;
        _allSongs = List.from(songs);
      });
      if (mounted) {
        context.read<AudioProvider>().restoreLastState(_songs);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading songs: $e')),
      );
    }
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _songs = List.from(_allSongs);
      } else {
        _songs = _allSongs.where((song) =>
        song.title.toLowerCase().contains(query.toLowerCase()) ||
            (song.artist != null && song.artist!.toLowerCase().contains(query.toLowerCase()))
        ).toList();
      }
    });
  }

  void _sortSongs(String criteria) {
    setState(() {
      if (criteria == 'Title') {
        _songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      } else if (criteria == 'Artist') {
        _songs.sort((a, b) => (a.artist ?? '').toLowerCase().compareTo((b.artist ?? '').toLowerCase()));
      } else if (criteria == 'Date') {
        _songs.sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !_hasPermission
                  ? _buildPermissionDenied()
                  : _songs.isEmpty
                  ? _buildNoSongs()
                  : _buildSongList(),
            ),
            Consumer<AudioProvider>(
              builder: (context, provider, child) {
                if (provider.currentSong == null) return const SizedBox.shrink();
                return MiniPlayer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _isSearching
                ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Tìm bài hát, nghệ sĩ...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: _filterSongs,
            )
                : const Text(
              'My Music',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.library_music, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaylistsScreen()),
                );
              },
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterSongs('');
                }
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: _sortSongs,
            icon: const Icon(Icons.sort, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Title', child: Text('Sắp xếp theo Tên')),
              const PopupMenuItem(value: 'Artist', child: Text('Sắp xếp theo Nghệ sĩ')),
              const PopupMenuItem(value: 'Date', child: Text('Mới thêm gần đây')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return SongTile(
          song: song,
          onTap: () {
            context.read<AudioProvider>().setPlaylist(_songs, index);
          },
        );
      },
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Storage Permission Required',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please grant storage permission to access music',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSongs() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.music_note, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No Music Found',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Add some music files to your device',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}