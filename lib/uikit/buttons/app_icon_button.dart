import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.yellow : Colors.white,
      iconSize: 30,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black26,
        shape: const CircleBorder(),
      ),
    );
  }
}