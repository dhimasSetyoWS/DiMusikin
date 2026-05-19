import 'package:flutter/material.dart';

// Model untuk musik
class Music {
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final Duration duration;

  Music({
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.duration,
  });
}

// Halaman Collection Musik
class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  // Warna dari requirement
  static const Color primaryColor = Color(0xFF33471D);
  static const Color secondaryColor = Color(0xFFA4A494);
  static const Color otherColor = Color(0xFFF6E5D0);

  // Data dummy untuk demo
  final List<Music> _allMusic = [
    Music(
      title: "Midnight Dreams",
      artist: "The Wanderers",
      album: "Night Sessions",
      coverUrl: "https://via.placeholder.com/150/33471d/ffffff?text=MD",
      duration: const Duration(minutes: 3, seconds: 45),
    ),
    Music(
      title: "Summer Breeze",
      artist: "Coastal Waves",
      album: "Horizon",
      coverUrl: "https://via.placeholder.com/150/a4a494/ffffff?text=SB",
      duration: const Duration(minutes: 4, seconds: 12),
    ),
    Music(
      title: "Electric Soul",
      artist: "Neon Knights",
      album: "Digital Dreams",
      coverUrl: "https://via.placeholder.com/150/f6e5d0/33471d?text=ES",
      duration: const Duration(minutes: 3, seconds: 28),
    ),
    Music(
      title: "Acoustic Sunrise",
      artist: "Morning Light",
      album: "Dawn Collection",
      coverUrl: "https://via.placeholder.com/150/33471d/ffffff?text=AS",
      duration: const Duration(minutes: 5, seconds: 3),
    ),
    Music(
      title: "Jazz Nights",
      artist: "The Smooth Collective",
      album: "Evening Mood",
      coverUrl: "https://via.placeholder.com/150/a4a494/ffffff?text=JN",
      duration: const Duration(minutes: 6, seconds: 15),
    ),
  ];

  List<Music> get _filteredMusic {
    if (_searchQuery.isEmpty) return _allMusic;
    return _allMusic
        .where((music) =>
            music.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            music.artist.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            music.album.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: otherColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(child: _buildMusicList()),
          ],
        ),
      ),
    );
  }

  // Header dengan judul dan stats
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your favorite tracks',
                    style: TextStyle(
                      color: Color(0xFFF6E5D0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard('${_allMusic.length}', 'Songs'),
              const SizedBox(width: 12),
              _buildStatCard('8', 'Albums'),
              const SizedBox(width: 12),
              _buildStatCard('12', 'Artists'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: otherColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: otherColor.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search music, artist, album...',
            hintStyle: TextStyle(color: secondaryColor),
            prefixIcon: Icon(Icons.search, color: primaryColor),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: secondaryColor),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  // Tab Bar
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: primaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'All Songs'),
          Tab(text: 'Recent'),
          Tab(text: 'Favorites'),
        ],
      ),
    );
  }

  // Music List
  Widget _buildMusicList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSongsList(_filteredMusic),
        _buildSongsList(_filteredMusic.take(3).toList()),
        _buildSongsList(_filteredMusic.reversed.take(2).toList()),
      ],
    );
  }

  Widget _buildSongsList(List<Music> songs) {
    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 80,
              color: secondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No music found',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return _buildMusicCard(songs[index], index);
      },
    );
  }

  Widget _buildMusicCard(Music music, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle music play
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Playing: ${music.title}'),
                backgroundColor: primaryColor,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Cover Image
                Hero(
                  tag: 'music_$index',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        music.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.music_note,
                            color: primaryColor,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Music Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        music.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33471D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        music.artist,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA4A494),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        music.album,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Duration
                Column(
                  children: [
                    Text(
                      _formatDuration(music.duration),
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Menu Button
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: secondaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.playlist_add, color: primaryColor),
                              const SizedBox(width: 12),
                              const Text('Add to Playlist'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.favorite_border, color: primaryColor),
                              const SizedBox(width: 12),
                              const Text('Add to Favorites'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.share, color: primaryColor),
                              const SizedBox(width: 12),
                              const Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: primaryColor),
                              const SizedBox(width: 12),
                              const Text('Info'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}