import 'package:camera/camera.dart';

class CameraService {
  Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      print("CameraService Error: $e");
      return [];
    }
  }
}