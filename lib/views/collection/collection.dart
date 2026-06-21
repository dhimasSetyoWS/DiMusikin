import 'package:flutter/material.dart';
import '../../models/music_model.dart';
import '../../controllers/music_controller.dart';
import '../player/music_player.dart';

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
  final MusicController _controller = MusicController();

  // Warna dari requirement
  static const Color primaryColor = Color(0xFF33471D);
  static const Color secondaryColor = Color(0xFFA4A494);
  static const Color otherColor = Color(0xFFF6E5D0);

  List<MusicModel> get _filteredMusic {
    final allMusic = _controller.musicList;
    if (_searchQuery.isEmpty) return allMusic;
    return allMusic
        .where((music) =>
            music.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            music.artis.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            music.album.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller.fetchMusicList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: otherColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildTabBar(),
                Expanded(
                  child: _controller.isLoading && _controller.musicList.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : _controller.errorMessage.isNotEmpty && _controller.musicList.isEmpty
                          ? Center(
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
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () => _controller.fetchMusicList(),
                                      icon: const Icon(Icons.refresh, color: Colors.white),
                                      label: const Text("Coba Lagi"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
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
                            )
                          : _buildMusicList(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showMusicFormSheet(),
        tooltip: 'Tambah Musik Baru',
        child: const Icon(Icons.add, color: otherColor, size: 28),
      ),
    );
  }

  // Header dengan judul dan stats
  Widget _buildHeader() {
    final songsCount = _controller.musicList.length;
    final albumsCount = _controller.musicList
        .map((m) => m.album.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .toSet()
        .length;
    final artistsCount = _controller.musicList
        .map((m) => m.artis.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .toSet()
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
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
              _buildStatCard('$songsCount', 'Songs'),
              const SizedBox(width: 12),
              _buildStatCard('$albumsCount', 'Albums'),
              const SizedBox(width: 12),
              _buildStatCard('$artistsCount', 'Artists'),
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
            hintStyle: const TextStyle(color: secondaryColor),
            prefixIcon: const Icon(Icons.search, color: primaryColor),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: secondaryColor),
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
    final recentSongs = _filteredMusic.take(3).toList();
    final favoriteSongs = _filteredMusic
        .where((m) => m.favorit.toLowerCase() == 'true' || m.favorit == '1')
        .toList();

    return TabBarView(
      controller: _tabController,
      children: [
        _buildSongsList(_filteredMusic),
        _buildSongsList(recentSongs),
        _buildSongsList(favoriteSongs),
      ],
    );
  }

  Widget _buildSongsList(List<MusicModel> songs) {
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
            const Text(
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

  Widget _buildMusicCard(MusicModel music, int index) {
    final bool isFavorite = music.favorit.toLowerCase() == 'true' || music.favorit == '1';

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
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Cover Image
                Hero(
                  tag: 'music_collection_${music.id}',
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
                        music.fotoSampul,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
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
                        music.judul,
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
                        music.artis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA4A494),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (music.album.isNotEmpty)
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
                // Duration & Menu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      music.durasi.isNotEmpty ? music.durasi : '00:00',
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Menu Button
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: secondaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showMusicFormSheet(music);
                        } else if (value == 'delete') {
                          _showDeleteConfirmDialog(music);
                        } else if (value == 'favorite') {
                          final updated = MusicModel(
                            id: music.id,
                            judul: music.judul,
                            artis: music.artis,
                            album: music.album,
                            genre: music.genre,
                            durasi: music.durasi,
                            fotoSampul: music.fotoSampul,
                            urlAudio: music.urlAudio,
                            jumlahPutar: music.jumlahPutar,
                            favorit: isFavorite ? 'false' : 'true',
                            lirik: music.lirik,
                            tanggalRilis: music.tanggalRilis,
                          );
                          _controller.updateMusic(updated);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Text(isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: primaryColor),
                              const SizedBox(width: 12),
                              Text('Edit Musik'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              const SizedBox(width: 12),
                              Text('Hapus Musik', style: TextStyle(color: Colors.red)),
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

  // Dialog Form (Add / Edit)
  void _showMusicFormSheet([MusicModel? music]) {
    final isEdit = music != null;
    final formKey = GlobalKey<FormState>();

    // Controllers
    final judulController = TextEditingController(text: isEdit ? music.judul : '');
    final artisController = TextEditingController(text: isEdit ? music.artis : '');
    final albumController = TextEditingController(text: isEdit ? music.album : '');
    final genreController = TextEditingController(text: isEdit ? music.genre : '');
    final durasiController = TextEditingController(text: isEdit ? music.durasi : '03:30');
    final fotoSampulController = TextEditingController(text: isEdit ? music.fotoSampul : '');
    final urlAudioController = TextEditingController(text: isEdit ? music.urlAudio : '');
    final lirikController = TextEditingController(text: isEdit ? music.lirik : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: otherColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Align(
                         alignment: Alignment.center,
                         child: Container(
                           width: 50,
                           height: 5,
                           decoration: BoxDecoration(
                             color: secondaryColor.withOpacity(0.5),
                             borderRadius: BorderRadius.circular(10),
                           ),
                         ),
                       ),
                       const SizedBox(height: 15),
                       Text(
                         isEdit ? 'Edit Musik ✏️' : 'Tambah Musik Baru 🎵',
                         style: const TextStyle(
                           color: primaryColor,
                           fontSize: 22,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 20),
                       _buildTextField('Judul Lagu', judulController, true),
                       const SizedBox(height: 12),
                       _buildTextField('Nama Artis / Band', artisController, true),
                       const SizedBox(height: 12),
                       _buildTextField('Album', albumController, false),
                       const SizedBox(height: 12),
                       Row(
                         children: [
                           Expanded(child: _buildTextField('Genre', genreController, false)),
                           const SizedBox(width: 12),
                           Expanded(child: _buildTextField('Durasi (contoh: 03:45)', durasiController, true)),
                         ],
                       ),
                       const SizedBox(height: 12),
                       _buildTextField(
                         'URL Foto Sampul',
                         fotoSampulController,
                         false,
                         hint: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f',
                       ),
                       const SizedBox(height: 12),
                       _buildTextField('URL Audio (MP3)', urlAudioController, false, hint: 'https://example.com/audio.mp3'),
                       const SizedBox(height: 12),
                       _buildTextField('Lirik (Opsional)', lirikController, false, maxLines: 3),
                       const SizedBox(height: 25),
                       SizedBox(
                         width: double.infinity,
                         height: 55,
                         child: ElevatedButton(
                           onPressed: isSaving ? null : () async {
                             if (formKey.currentState!.validate()) {
                               setModalState(() {
                                 isSaving = true;
                               });
                               
                               final newOrUpdatedMusic = MusicModel(
                                 id: isEdit ? music.id : '',
                                 judul: judulController.text.trim(),
                                 artis: artisController.text.trim(),
                                 album: albumController.text.trim(),
                                 genre: genreController.text.trim(),
                                 durasi: durasiController.text.trim(),
                                 fotoSampul: fotoSampulController.text.trim().isNotEmpty
                                     ? fotoSampulController.text.trim()
                                     : 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f',
                                 urlAudio: urlAudioController.text.trim(),
                                 jumlahPutar: isEdit ? music.jumlahPutar : 0,
                                 favorit: isEdit ? music.favorit : 'false',
                                 lirik: lirikController.text.trim(),
                                 tanggalRilis: isEdit ? music.tanggalRilis : DateTime.now().millisecondsSinceEpoch,
                               );

                               bool success;
                               if (isEdit) {
                                 success = await _controller.updateMusic(newOrUpdatedMusic);
                               } else {
                                 success = await _controller.addMusic(newOrUpdatedMusic);
                               }

                               if (success) {
                                 Navigator.pop(context);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                     content: Text(isEdit 
                                         ? 'Musik "${newOrUpdatedMusic.judul}" berhasil diperbarui!' 
                                         : 'Musik "${newOrUpdatedMusic.judul}" berhasil ditambahkan!'),
                                     backgroundColor: primaryColor,
                                   ),
                                 );
                               } else {
                                 setModalState(() {
                                   isSaving = false;
                                 });
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                     content: Text('Gagal menyimpan musik: ${_controller.errorMessage}'),
                                     backgroundColor: Colors.red,
                                   ),
                                 );
                               }
                             }
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: primaryColor,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15),
                             ),
                           ),
                           child: isSaving 
                               ? const SizedBox(
                                   height: 24,
                                   width: 24,
                                   child: CircularProgressIndicator(color: otherColor, strokeWidth: 2),
                                 )
                               : Text(
                                   isEdit ? 'Perbarui Musik' : 'Tambah Musik',
                                   style: const TextStyle(
                                     color: otherColor,
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             );
           },
         );
       },
     );
   }

   Widget _buildTextField(
     String label,
     TextEditingController controller,
     bool isRequired, {
     String? hint,
     int maxLines = 1,
   }) {
     return TextFormField(
       controller: controller,
       maxLines: maxLines,
       validator: (value) {
         if (isRequired && (value == null || value.trim().isEmpty)) {
           return '$label tidak boleh kosong';
         }
         return null;
       },
       decoration: InputDecoration(
         labelText: label,
         labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
         hintText: hint,
         hintStyle: TextStyle(color: secondaryColor.withOpacity(0.7)),
         filled: true,
         fillColor: Colors.white,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: BorderSide.none,
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(color: primaryColor, width: 1.5),
         ),
         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
       ),
     );
   }

  // Dialog Konfirmasi Hapus
  void _showDeleteConfirmDialog(MusicModel music) {
    showDialog(
      context: context,
      builder: (context) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: otherColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Hapus Musik 🗑️',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Apakah Anda yakin ingin menghapus lagu "${music.judul}" oleh ${music.artis} dari koleksi?',
                style: const TextStyle(color: Colors.black87),
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting ? null : () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: secondaryColor)),
                ),
                ElevatedButton(
                  onPressed: isDeleting ? null : () async {
                    setDialogState(() {
                      isDeleting = true;
                    });

                    final success = await _controller.deleteMusic(music.id);

                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Musik "${music.judul}" berhasil dihapus!'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menghapus musik: ${_controller.errorMessage}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isDeleting 
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Hapus', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}