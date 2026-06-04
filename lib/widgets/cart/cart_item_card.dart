import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';

class CartItemCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String? image;

  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    this.image,
    required this.onAdd,
    required this.onRemove,
  });

  String? get _resolvedImage {
    if (image == null || image!.isEmpty) {
      return null;
    }

    return image!.startsWith('http')
        ? image
        : '${ApiService.baseUrl.replaceAll('/api', '')}$image';
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = price * quantity;
    final imageUrl = _resolvedImage;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(14),
            child: SizedBox(
              width: 76,
              height: 76,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        AppColors.textDark,
                  ),
                ),

                if (description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 2,
                    ),
                    child: Text(
                      description,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color:
                            AppColors
                                .textLight,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(
                      'Rp ${_format(subtotal)}',
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w800,
                        color: AppColors
                            .primaryRed,
                      ),
                    ),

                    Container(
                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .bgSurface,
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize
                                .min,
                        children: [
                          _QtyButton(
                            icon: Icons
                                .remove_rounded,
                            onTap:
                                onRemove,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                            ),
                            child: Text(
                              '$quantity',
                            ),
                          ),
                          _QtyButton(
                            icon: Icons
                                .add_rounded,
                            isAdd:
                                true,
                            onTap:
                                onAdd,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.bgSurface,
      child: const Icon(
        Icons.ramen_dining_rounded,
        color: AppColors.borderMedium,
      ),
    );
  }

  String _format(double amount) {
    String result =
        amount.toInt().toString();

    final reg = RegExp(
      r'(\d{1,3})(?=(\d{3})+(?!\d))',
    );

    return result.replaceAllMapped(
      reg,
      (m) => '${m[1]}.',
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isAdd
              ? AppColors.primaryRed
              : AppColors.bgSurfaceLight,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isAdd
              ? AppColors.textWhite
              : AppColors.textMedium,
        ),
      ),
    );
  }
}