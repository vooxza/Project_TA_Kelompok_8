import 'package:flutter/material.dart';

/// Tombol ikon bulat mengambang (back / edit) di atas gambar hero
/// Product Detail. Dipakai bareng oleh versi mobile & wide.
class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color iconColor;

  const CircleButton({
    required this.icon,
    required this.onTap,
    required this.bg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
