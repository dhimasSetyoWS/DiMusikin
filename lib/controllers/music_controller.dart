import 'package:flutter/material.dart';
import '../models/music_model.dart';
import '../services/api_service.dart';

class MusicController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<MusicModel> _musicList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<MusicModel> get musicList => _musicList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Memuat daftar musik dari API
  Future<void> fetchMusicList() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _musicList = await _apiService.fetchMusicList();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mencari musik dari API
  Future<void> searchMusic(String query) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _musicList = await _apiService.searchMusic(query);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambah musik baru ke API dan list lokal
  Future<bool> addMusic(MusicModel music) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newMusic = await _apiService.addMusic(music);
      _musicList.insert(0, newMusic);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memperbarui musik di API dan list lokal
  Future<bool> updateMusic(MusicModel music) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final updatedMusic = await _apiService.updateMusic(music);
      final index = _musicList.indexWhere((m) => m.id == music.id);
      if (index != -1) {
        _musicList[index] = updatedMusic;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menghapus musik dari API dan list lokal
  Future<bool> deleteMusic(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _apiService.deleteMusic(id);
      _musicList.removeWhere((m) => m.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
