import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/homepage_controller.dart';

class PaketCarousel extends GetView<HomePageController> {
  const PaketCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgGrey,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Paket Terlaris!',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            final current = controller.currentPaketIndex.value;
            final total = controller.paketList.length;
            final paket = controller.paketList[current];

            return Column(
              children: [
                _PaketCard(
                  paket: paket,
                  current: current,
                  total: total,
                  onSwipeLeft: () =>
                      controller.goToPaket((current + 1) % total),
                  onSwipeRight: () =>
                      controller.goToPaket((current - 1 + total) % total),
                ),
                const SizedBox(height: 14),
                _DotIndicator(total: total, current: current),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _PaketCard extends StatelessWidget {
  final Map<String, dynamic> paket;
  final int current;
  final int total;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const _PaketCard({
    required this.paket,
    required this.current,
    required this.total,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          onSwipeLeft();
        } else if (details.primaryVelocity! > 0) {
          onSwipeRight();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
        child: Container(
          key: ValueKey(current),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              _PaketImage(imagePath: paket['image']),
              _PaketInfo(paket: paket),
              const _PaketCartButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaketImage extends StatelessWidget {
  final String imagePath;

  const _PaketImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      child: Image.asset(
        imagePath,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: const Icon(
            Icons.fastfood,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _PaketInfo extends StatelessWidget {
  final Map<String, dynamic> paket;

  const _PaketInfo({required this.paket});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paket['nama'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              paket['deskripsi'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              paket['harga'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE8A020),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaketCartButton extends StatelessWidget {
  const _PaketCartButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int total;
  final int current;

  const _DotIndicator({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryRed : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}