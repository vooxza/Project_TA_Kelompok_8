import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../theme/colors.dart';
import '../controllers/add_menu_controller.dart';

class AddMenuPage extends StatelessWidget {
  const AddMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddMenuController controller = Get.put(AddMenuController());

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Tambahkan Menu',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Menu Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Image Section
                    GestureDetector(
                      onTap: () {
                        controller.pickImageFromGallery();
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          color: AppColors.bgGreyLight,
                          child: Obx(
                            () {
                              final imagePath = controller.selectedImage.value;
                              if (imagePath == null) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 50, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to select image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              // Check if it's a file path or asset path
                              if (imagePath.startsWith('assets')) {
                                return Image.asset(imagePath, fit: BoxFit.cover);
                              } else {
                                return Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            controller: controller.nameController,
                            label: 'Nama',
                            hint: 'Nama menu...',
                          ),

                          const SizedBox(height: 15),

                          _buildInputField(
                            controller: controller.priceController,
                            label: 'Harga',
                            hint: 'Harga menu...',
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 20),

                          // Action Button
                          GestureDetector(
                            onTap: () => controller.addMenu(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Tambahkan',
                                  style: TextStyle(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

