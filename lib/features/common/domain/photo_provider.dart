import 'package:camera_app/core/data/storage_service.dart';
import 'package:flutter/foundation.dart';

class PhotoProvider extends ChangeNotifier {
  final StorageService _storage;
  PhotoProvider({required StorageService storageService})
    : _storage = storageService;

  List<String> _paths = [];
  bool _isLoading = false;

  List<String> get paths => _paths;
  bool get isLoading => _isLoading;

  Future<void> loadPhotos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _paths = await _storage.getSavedPaths();
    } catch (e) {
      debugPrint('Ошибка загрузки фото: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPhoto(String path) async {
    try {
      await _storage.saveImagePath(path);
      await loadPhotos();
    } catch (e) {
      debugPrint('Ошибка сохранения фото: $e');
    }
  }
}
