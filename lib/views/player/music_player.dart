import 'package:flutter/material.dart';

class MusicPlayer extends StatelessWidget {
  final String title;
  final String artist;

  const MusicPlayer({
    super.key,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071126),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [

                /// TOP BAR
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const Text(
                      "Now Playing",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                /// ALBUM COVER
                Container(
                  height: 280,
                  width: 280,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),

                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
                      ),
                      fit: BoxFit.cover,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 25,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// SONG TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// ARTIST
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 35),

                /// SLIDER
                Slider(
                  value: 45,
                  max: 100,
                  activeColor: const Color(0xFFF6E5D0),
                  inactiveColor: Colors.white24,
                  onChanged: (value) {},
                ),

                /// TIME
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      "1:24",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    Text(
                      "3:45",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                /// CONTROL BUTTONS
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                  children: [

                    const Icon(
                      Icons.shuffle,
                      color: Colors.white70,
                      size: 30,
                    ),

                    const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white,
                      size: 45,
                    ),

                    Container(
                      padding: const EdgeInsets.all(22),

                      decoration: const BoxDecoration(
                        color: Color(0xFFF6E5D0),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.pause,
                        color: Color(0xFF33471D),
                        size: 40,
                      ),
                    ),

                    const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: 45,
                    ),

                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white70,
                      size: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}