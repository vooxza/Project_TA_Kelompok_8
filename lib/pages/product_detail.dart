import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../core/services/api_service.dart';
import '../core/services/role_service.dart';
import '../routes/app_routes.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments;
    final cartController = Get.find<CartController>();

    final String? imageUrl = _resolveImage(item.image);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: Column(
        children: [
          // Image hero
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _PlaceholderHero(),
                        )
                      : _PlaceholderHero(),
                ),

                // Bottom gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.bgWhite, Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // Top actions
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Get.back(),
                          bg: AppColors.bgWhite,
                          iconColor: AppColors.textDark,
                        ),
                        if (RoleService.isAdmin)
                          _CircleButton(
                            icon: Icons.edit_rounded,
                            onTap: () => Get.toNamed(
                              AppRoutes.editMenu,
                              arguments: {
                                'id': item.id,
                                'name': item.name,
                                'description': item.description,
                                'category_id': item.categoryId,
                                'price': item.price,
                                'image': item.image,
                              },
                            ),
                            bg: AppColors.primaryRed,
                            iconColor: AppColors.textWhite,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Rp ${_fmtPrice(item.price)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description != null && item.description!.isNotEmpty
                        ? item.description!
                        : 'Tidak ada deskripsi tersedia.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  // Bottom action
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      children: [
                        // Price label
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Harga',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                ),
                              ),
                              Text(
                                'Rp ${_fmtPrice(item.price)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Add to cart
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              cartController.addToCart(item);
                              Get.back();
                              Get.snackbar(
                                'Ditambahkan!',
                                '${item.name} masuk ke keranjang',
                                backgroundColor: AppColors.primaryRed,
                                colorText: AppColors.textWhite,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(12),
                                borderRadius: 12,
                                duration: const Duration(seconds: 2),
                                icon: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              );
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRed.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_shopping_cart_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tambah',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }

  String? _resolveImage(String? image) {
    if (image == null || image.isEmpty) return null;
    return image.startsWith('http')
        ? image
        : '${ApiService.baseUrl.replaceAll('/api', '')}$image';
  }

  String _fmtPrice(double price) {
    String result = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return result.replaceAllMapped(reg, (m) => '${m[1]}.');
  }
}

class _PlaceholderHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: const Center(
        child: Icon(
          Icons.ramen_dining_rounded,
          size: 80,
          color: AppColors.borderMedium,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color iconColor;

  const _CircleButton({
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
