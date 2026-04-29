import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ImagePickerBox extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ImagePickerBox({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgGreyLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: imagePath == null
            ? const Icon(Icons.image, size: 50, color: Colors.grey)
            : imagePath!.startsWith('http')
            ? Image.network(imagePath!, fit: BoxFit.cover)
            : imagePath!.startsWith('assets')
            ? Image.asset(imagePath!, fit: BoxFit.cover)
            : Image.file(File(imagePath!), fit: BoxFit.cover),
      ),
    );
  }
}
