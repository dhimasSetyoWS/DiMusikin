class MusicModel {
  final String id;
  final String judul;
  final String artis;
  final String album;
  final String genre;
  final String durasi;
  final String fotoSampul;
  final String urlAudio;
  final int jumlahPutar;
  final String favorit;
  final String lirik;
  final int tanggalRilis;

  MusicModel({
    required this.id,
    required this.judul,
    required this.artis,
    required this.album,
    required this.genre,
    required this.durasi,
    required this.fotoSampul,
    required this.urlAudio,
    required this.jumlahPutar,
    required this.favorit,
    required this.lirik,
    required this.tanggalRilis,
  });

  // Factory constructor untuk membuat object dari JSON
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? 'Unknown Title',
      artis: json['artis'] ?? 'Unknown Artist',
      album: json['album'] ?? '',
      genre: json['genre'] ?? '',
      durasi: json['durasi'] ?? '',
      fotoSampul: json['foto_sampul'] ?? 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f',
      urlAudio: json['url_audio'] ?? '',
      jumlahPutar: json['jumlah_putar'] is int ? json['jumlah_putar'] : int.tryParse(json['jumlah_putar']?.toString() ?? '0') ?? 0,
      favorit: json['favorit']?.toString() ?? '',
      lirik: json['lirik'] ?? '',
      tanggalRilis: json['tanggal_rilis'] is int ? json['tanggal_rilis'] : int.tryParse(json['tanggal_rilis']?.toString() ?? '0') ?? 0,
    );
  }

  // Method untuk convert model kembali ke JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'artis': artis,
      'album': album,
      'genre': genre,
      'durasi': durasi,
      'foto_sampul': fotoSampul,
      'url_audio': urlAudio,
      'jumlah_putar': jumlahPutar,
      'favorit': favorit,
      'lirik': lirik,
      'tanggal_rilis': tanggalRilis,
    };
  }
}
