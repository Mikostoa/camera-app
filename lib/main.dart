import 'package:camera_app/api/service/camera_service.dart';
import 'package:camera_app/core/data/storage_service.dart';
import 'package:camera_app/features/common/domain/photo_provider.dart';
import 'package:camera_app/features/places/ui/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  final cameraService = CameraService();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storageService),
        Provider.value(value: cameraService),

        ChangeNotifierProvider(
          create: (context) => PhotoProvider(storageService: context.read<StorageService>())..loadPhotos(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Collection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, 
        ),
      ),
      home: PlacesScreen(),
    );
  }
}