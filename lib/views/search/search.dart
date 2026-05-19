import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

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

  final List<Map<String, String>> musicList = [
    {"title": "Golden Night", "artist": "Ariana"},
    {"title": "Lost Memory", "artist": "Justin"},
    {"title": "Night Drive", "artist": "The Weeknd"},
    {"title": "Dream Sky", "artist": "Taylor Swift"},
  ];

  List<Map<String, String>> filteredMusic = [];

  void searchMusic(String query) {
    final results =
        musicList.where((music) {
          final title = music['title']!.toLowerCase();
          final artist = music['artist']!.toLowerCase();

          return title.contains(query.toLowerCase()) ||
              artist.contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredMusic = results;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredMusic = musicList;
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

              ListView.builder(
                itemCount: filteredMusic.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final music = filteredMusic[index];

                  return Container(
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
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                music['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3F4A2C),
                                ),
                              ),
                              Text(
                                music['artist']!,
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
