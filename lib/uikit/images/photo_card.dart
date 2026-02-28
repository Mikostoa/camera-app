import 'dart:io';
import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  final String path;

  const PhotoCard({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(File(path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

