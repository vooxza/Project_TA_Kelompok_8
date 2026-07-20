import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/cart/cart_empty.dart';
import '../../widgets/cart/cart_item_card.dart';
import '../../widgets/dialog_button.dart';
import '../../widgets/cart/summary_panel_wide.dart';

/// Konfirmasi hapus item keranjang, pakai [CustomDialog] yang sama seperti
/// dialog "Batalkan Pesanan?" di halaman Pembayaran.
void _confirmDelete(CartController controller, int productId, String name) {
  Get.dialog(
    CustomDialog(
      title: 'Hapus Item?',
      message: 'Yakin ingin menghapus "$name" dari keranjang?',
      textCancel: 'Batal',
      textConfirm: 'Ya, Hapus',
      onCancel: () => Get.back(),
      onConfirm: () => controller.removeFromCart(productId),
    ),
  );
}

/// Versi widescreen dari CartPage. Data & aksi (tambah/kurang qty, atas
/// nama, checkout) sama persis dengan versi mobile — hanya reflow: daftar
/// item jadi grid beberapa kolom di kiri, ringkasan pembayaran jadi panel
/// tetap di kanan (tidak perlu scroll ke bawah untuk checkout).
class CartPageWide extends GetView<CartController> {
  const CartPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgCream,
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
            child: Obx(() {
              final isEmpty = controller.cartItems.isEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 26, 28, 8),
                    child: Row(
                      children: [
                        const Text(
                          'Keranjang',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (controller.cartItems.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${controller.cartItems.length} item',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isEmpty)
                    const Expanded(child: CartEmpty())
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kiri: daftar item keranjang
                            Expanded(
                              flex: 2,
                              child: ListView.separated(
                                itemCount: controller.cartItems.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final item = controller.cartItems[index];
                                  return Obx(
                                    () => CartItemCard(
                                      title: item.product.name,
                                      description:
                                          item.product.description ?? '',
                                      price: item.product.price,
                                      quantity: item.quantity.value,
                                      image: item.product.image,
                                      onAdd: () => controller
                                          .incrementQuantity(
                                              item.product.id ?? 0),
                                      onRemove: () => controller
                                          .decrementQuantity(
                                              item.product.id ?? 0),
                                      onDelete: () => _confirmDelete(
                                        controller,
                                        item.product.id ?? 0,
                                        item.product.name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Kanan: ringkasan & checkout
                            SizedBox(
                              width: 300,
                              child: SummaryPanelWide(controller: controller),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
