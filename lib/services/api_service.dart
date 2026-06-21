import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

class ApiService {
  static String baseUrl = 'https://6a28c4834e1e783349a5f87b.mockapi.io';

  /// Mengambil semua daftar musik
  Future<List<MusicModel>> fetchMusicList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/musik'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => MusicModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal memuat musik: Status Code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi: $e');
    }
  }

  /// Melakukan pencarian musik berdasarkan judul atau artis
  Future<List<MusicModel>> searchMusic(String query) async {
    try {
      // Jika mockAPI mendukung query pencarian seperti /musik?search=judul
      final response = await http.get(
        Uri.parse('$baseUrl/musik?search=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => MusicModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal mencari musik: Status Code ${response.statusCode}',
        );
      }
    } catch (e) {
      // Fallback: ambil semua list musik lalu filter secara lokal
      try {
        final allMusic = await fetchMusicList();
        final lowerQuery = query.toLowerCase();
        return allMusic.where((music) {
          return music.judul.toLowerCase().contains(lowerQuery) ||
              music.artis.toLowerCase().contains(lowerQuery) ||
              music.album.toLowerCase().contains(lowerQuery);
        }).toList();
      } catch (innerError) {
        throw Exception('Kesalahan Koneksi saat mencari musik: $e');
      }
    }
  }

  /// Menambah musik baru ke API
  Future<MusicModel> addMusic(MusicModel music) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/musik'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(music.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return MusicModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal menambah musik: Status Code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi: $e');
    }
  }

  /// Memperbarui data musik di API
  Future<MusicModel> updateMusic(MusicModel music) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/musik/${music.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(music.toJson()),
      );

      if (response.statusCode == 200) {
        return MusicModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal memperbarui musik: Status Code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi: $e');
    }
  }

  /// Menghapus musik dari API
  Future<void> deleteMusic(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/musik/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Gagal menghapus musik: Status Code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi: $e');
    }
  }
}
