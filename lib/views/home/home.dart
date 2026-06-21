import 'package:flutter/material.dart';
import '../../models/music_model.dart';
import '../../controllers/music_controller.dart';
import '../player/music_player.dart';
import '../search/search.dart';
import '../collection/collection.dart';
import '../profile/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    SearchPage(),
    CollectionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      /// DRAWER
      drawer: Drawer(
        backgroundColor: const Color(0xFFFAFAFA),

        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            /// HEADER DRAWER
            Container(
              height: 230,
              padding: const EdgeInsets.all(25),

              decoration: const BoxDecoration(
                color: Color(0xFF33471D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,

                    child: Icon(
                      Icons.person,
                      color: Color(0xFF33471D),
                      size: 38,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Hello User 🎵",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Enjoy your music today",
                    style: TextStyle(
                      color: Color(0xFFA4A494),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PROFILE
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: const Color(0xFFF6E5D0),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF33471D),
                ),
              ),

              title: const Text(
                "Profile",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () {
                Navigator.pop(context);

                setState(() {
                  selectedIndex = 3;
                });
              },
            ),

            /// SETTINGS
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: const Color(0xFFF6E5D0),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF33471D),
                ),
              ),

              title: const Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () {},
            ),

            /// LOGOUT
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),

              title: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () {},
            ),
          ],
        ),
      ),

      /// BODY
      body: pages[selectedIndex],

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: const Color(0xFF33471D),
          borderRadius: BorderRadius.circular(30),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ],
        ),

        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          currentIndex: selectedIndex,

          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFFA4A494),

          type: BottomNavigationBarType.fixed,

          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_rounded),
              label: 'Collection',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final MusicController _controller = MusicController();

  @override
  void initState() {
    super.initState();
    _controller.fetchMusicList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF33471D),
              ),
            );
          }

          if (_controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _controller.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _controller.fetchMusicList(),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33471D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_controller.musicList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tidak ada musik yang tersedia"),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => _controller.fetchMusicList(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33471D),
                    ),
                    child: const Text("Segarkan", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          final featuredMusic = _controller.musicList.first;
          final recentlyPlayed = _controller.musicList.skip(1).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =========================
                /// TOP BAR MODERN
                /// =========================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// MENU
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6E5D0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.menu_rounded,
                              color: Color(0xFF33471D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      /// GARIS PEMBATAS
                      Container(
                        width: 1.5,
                        height: 35,
                        color: const Color(0xFFE0E0E0),
                      ),
                      const SizedBox(width: 15),
                      /// TITLE
                      const Expanded(
                        child: Text(
                          "DiMusikin",
                          style: TextStyle(
                            color: Color(0xFF33471D),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      /// SEARCH
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF33471D),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// GREETING
                const Text(
                  "Feel The Music 🎧",
                  style: TextStyle(
                    color: Color(0xFF33471D),
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Nikmati musik favoritmu dengan tampilan modern",
                  style: TextStyle(
                    color: Color(0xFFA4A494),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                /// FEATURED MUSIC
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    image: DecorationImage(
                      image: NetworkImage(featuredMusic.fotoSampul),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Trending",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          featuredMusic.judul,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${featuredMusic.artis} • ${featuredMusic.album}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicPlayer(
                                  title: featuredMusic.judul,
                                  artist: featuredMusic.artis,
                                  fotoSampul: featuredMusic.fotoSampul,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6E5D0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Color(0xFF33471D),
                                  size: 28,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Play Now",
                                  style: TextStyle(
                                    color: Color(0xFF33471D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// RECENTLY PLAYED
                const Text(
                  "Recently Played",
                  style: TextStyle(
                    color: Color(0xFF33471D),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 270,
                  child: recentlyPlayed.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada musik lainnya",
                            style: TextStyle(color: Color(0xFFA4A494)),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recentlyPlayed.length,
                          itemBuilder: (context, index) {
                            final music = recentlyPlayed[index];
                            return ModernMusicCard(
                              image: music.fotoSampul,
                              title: music.judul,
                              artist: music.artis,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ModernMusicCard extends StatelessWidget {
  final String image;
  final String title;
  final String artist;

  const ModernMusicCard({
    super.key,
    required this.image,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.85),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              artist,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayer(
                          title: title,
                          artist: artist,
                          fotoSampul: image,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6E5D0),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFF33471D),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}