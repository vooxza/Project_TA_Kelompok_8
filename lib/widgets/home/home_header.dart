import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan ini untuk mengatur warna icon status bar
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryRed, // Pastikan warna ini sesuai di app_colors.dart
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      // SafeArea memastikan konten di dalamnya tidak kena notch/kamera
      child: SafeArea(
        bottom: false, // Kita hanya butuh aman di area atas (kamera)
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BARIS SEARCH & PROFILE ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
              
              const SizedBox(height: 25),

              // --- TEKS WELCOME ---
              const Text(
                "Welcome!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              // --- TEKS MAU PESAN APA ---
              const Text(
                "Mau Pesan Apa?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}