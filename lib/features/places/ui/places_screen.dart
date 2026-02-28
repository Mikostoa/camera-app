import 'package:camera_app/features/camera/ui/camera_screen.dart';
import 'package:camera_app/features/common/domain/photo_provider.dart';
import 'package:camera_app/uikit/images/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoProvider>().loadPhotos();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Моя коллекция')),
      body: SafeArea(
        child: Consumer<PhotoProvider>(
          builder: (context, provider, child) {
            if (provider.paths.isEmpty) {
              return const Center(child: Text('Нет фотографий'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: provider.paths.length,
              itemBuilder: (context, index) {
                if (provider.paths.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 80,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ваша коллекция пока пуста',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const Text(
                          'Нажмите на кнопку, чтобы сделать первое фото',
                        ),
                      ],
                    ),
                  );
                }
                final path = provider.paths[index];
                return PhotoCard(path: path);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CameraScreen()),
        ),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
