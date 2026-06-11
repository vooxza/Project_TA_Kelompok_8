import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/services/api_service.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_badge_button.dart';

class MenuCard extends StatelessWidget {
  final dynamic item;
  final CartController cartController;

  const MenuCard({
    super.key,
    required this.item,
    required this.cartController,
  });

  String _resolveImageUrl(String? image) {
    if (image == null || image.isEmpty) return '';
    return image.startsWith('http')
        ? image
        : '${ApiService.baseUrl.replaceAll('/api', '')}$image';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl(item.image);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowWarm,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _PlaceholderImage(),
                          )
                        : _PlaceholderImage(),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0x401A0A0A),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (RoleService.isAdmin)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
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
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.bgWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: AppColors.primaryRed,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,       // sebelumnya 13
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,       // sebelumnya 11
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${_formatPrice(item.price)}',
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,   // sebelumnya 13
                        ),
                      ),
                      CartBadgeButton(
                        item: item,
                        cartController: cartController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final int amount = price.toInt();
    String result = amount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return result.replaceAllMapped(reg, (m) => '${m[1]}.');
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.ramen_dining_rounded,
              size: 36,
              color: AppColors.borderMedium,
            ),
          ],
        ),
      ),
    );
  }
}