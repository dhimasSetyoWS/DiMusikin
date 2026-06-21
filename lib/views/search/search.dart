import 'package:flutter/material.dart';
import '../../models/music_model.dart';
import '../../controllers/music_controller.dart';
import '../player/music_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final MusicController _controller = MusicController();

  final List<Map<String, String>> popularAlbums = [
    {
      "title": "Midnight Echo",
      "artist": "Ariana",
      "image": "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
    },
    {
      "title": "Dream Lights",
      "artist": "Justin",
      "image": "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
    },
    {
      "title": "Sky Vibes",
      "artist": "The Weeknd",
      "image": "https://images.unsplash.com/photo-1501386761578-eac5c94b800a",
    },
  ];

  void searchMusic(String query) {
    if (query.trim().isEmpty) {
      _controller.fetchMusicList();
    } else {
      _controller.searchMusic(query);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.fetchMusicList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE7E1),
      appBar: AppBar(
        backgroundColor: const Color(0xff3F4A2C),
        elevation: 0,
        title: const Text(
          "Search Music",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: searchMusic,
                  decoration: InputDecoration(
                    hintText: "Cari musik atau artist...",
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Album Populer",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3F4A2C),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularAlbums.length,
                  itemBuilder: (context, index) {
                    final album = popularAlbums[index];

                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xffD9C7A7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.network(
                              album['image']!,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  album['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff3F4A2C),
                                  ),
                                ),
                                Text(
                                  album['artist']!,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Musik Populer",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3F4A2C),
                ),
              ),

              const SizedBox(height: 15),

              ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  if (_controller.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(
                          color: Color(0xff3F4A2C),
                        ),
                      ),
                    );
                  }

                  if (_controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              _controller.errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => searchMusic(searchController.text),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3F4A2C),
                              ),
                              child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  if (_controller.musicList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          "Musik tidak ditemukan",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _controller.musicList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final music = _controller.musicList[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayer(
                                title: music.judul,
                                artist: music.artis,
                                fotoSampul: music.fotoSampul,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5EFE4),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xff3F4A2C),
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(music.fotoSampul),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      music.judul,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3F4A2C),
                                      ),
                                    ),
                                    Text(
                                      music.artis,
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.play_circle_fill,
                                color: Color(0xff3F4A2C),
                                size: 35,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
