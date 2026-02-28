import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _key = 'saved_photos_paths';

  Future<void> saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> paths = prefs.getStringList(_key) ?? [];
    paths.insert(0, path);
    await prefs.setStringList(_key, paths);
  }

  Future<List<String>> getSavedPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}