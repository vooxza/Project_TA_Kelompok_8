import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/services/api_service.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/product_detail/circle_button.dart';
import '../../widgets/product_detail/placeholder_hero.dart';

/// Versi widescreen dari ProductDetailPage. Data & aksi (tambah ke
/// keranjang, edit menu untuk admin) sama persis dengan versi mobile —
/// direflow jadi dua kolom: gambar besar di kiri, info produk + tombol
/// tambah di kanan (bukan ditumpuk vertikal).
class ProductDetailPageWide extends StatelessWidget {
  const ProductDetailPageWide({super.key});

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

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments;
    final cartController = Get.find<CartController>();
    final String? imageUrl = _resolveImage(item.image);

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: gambar hero
                Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const PlaceholderHero(),
                                )
                              : const PlaceholderHero(),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: CircleButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Get.back(),
                            bg: AppColors.bgWhite,
                            iconColor: AppColors.textDark,
                          ),
                        ),
                        if (RoleService.isAdmin)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: CircleButton(
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
                          ),
                      ],
                    ),
                  ),
                ),

                // Kanan: info produk
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${_fmtPrice(item.price)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: 20),
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description != null &&
                                  item.description!.isNotEmpty
                              ? item.description!
                              : 'Tidak ada deskripsi tersedia.',
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textLight,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Tambah ke Keranjang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
