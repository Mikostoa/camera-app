import 'package:camera/camera.dart';
import 'package:camera_app/api/service/camera_service.dart';
import 'package:camera_app/features/common/domain/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isTimerEnabled = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameraService = CameraService();
    final cameras = await cameraService.getAvailableCameras();

    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() {});
    } else {}
  }

  int _countdown = 0;

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isTimerEnabled) {
      for (int i = 3; i > 0; i--) {
        setState(() => _countdown = i);
        await Future.delayed(const Duration(seconds: 1));
      }
      setState(() => _countdown = 0);
    }

    final image = await _controller!.takePicture();

    if (mounted) {
      await context.read<PhotoProvider>().addPhoto(image.path);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Positioned.fill(
            child: Transform.scale(
              scale: scale,
              child: Center(child: CameraPreview(_controller!)),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBlurButton(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(120, 0, 0, 0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _flashMode == FlashMode.torch
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _flashMode = _flashMode == FlashMode.off
                                  ? FlashMode.torch
                                  : FlashMode.off;
                              _controller!.setFlashMode(_flashMode);
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _isTimerEnabled ? Icons.timer : Icons.timer_off,
                              color: _isTimerEnabled
                                  ? Colors.yellow
                                  : Colors.white,
                            ),
                            onPressed: () => setState(
                              () => _isTimerEnabled = !_isTimerEnabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                color: const Color.fromARGB(120, 0, 0, 0),
                child: Center(
                  child: GestureDetector(
                    onTap: _takePicture,
                    child: _buildShutterButton(),
                  ),
                ),
              ),
            ),
          ),

          if (_countdown > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    fontSize: 150,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBlurButton({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(120, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }

  Widget _buildShutterButton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(120, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
