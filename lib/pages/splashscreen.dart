import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Get.offNamed('/startingscreen');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6D1212),
              Color(0xFF9B1B1B),
              Color(0xFFBF2626),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGold.withOpacity(0.08),
                ),
              ),
            ),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo container
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.textWhite,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.restaurant,
                                    size: 48,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Restaurant name
                            const Text(
                              'Warung Soto',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 2,
                                  color: AppColors.accentGold,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Mbok Kerso',
                                  style: TextStyle(
                                    color: AppColors.accentGoldLight,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 2,
                                  color: AppColors.accentGold,
                                ),
                              ],
                            ),

                            const SizedBox(height: 60),

                            // Loading indicator
                            SizedBox(
                              width: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.accentGold,
                                  ),
                                  minHeight: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnim,
                builder: (context, _) => Opacity(
                  opacity: _fadeAnim.value,
                  child: const Text(
                    'Cita Rasa Asli Nusantara',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}