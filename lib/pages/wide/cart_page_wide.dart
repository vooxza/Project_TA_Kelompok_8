import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/cart/cart_empty.dart';
import '../../widgets/cart/cart_header_wide.dart';
import '../../widgets/cart/cart_item_card.dart';
import '../../widgets/cart/summary_panel_wide.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/dialog_button.dart';

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
/// item di kiri, ringkasan pembayaran jadi panel tetap di kanan (tidak
/// perlu scroll ke bawah untuk checkout). Memakai [WidePageContainer]
/// supaya tampilannya satu kanvas cream penuh.
class CartPageWide extends GetView<CartController> {
  const CartPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      child: Obx(() {
        final isEmpty = controller.cartItems.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CartHeaderWide(itemCount: controller.cartItems.length),
            const SizedBox(height: 18),
            if (isEmpty)
              const Expanded(child: CartEmpty())
            else
              Expanded(
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
                              description: item.product.description ?? '',
                              price: item.product.price,
                              quantity: item.quantity.value,
                              image: item.product.image,
                              onAdd: () => controller
                                  .incrementQuantity(item.product.id ?? 0),
                              onRemove: () => controller
                                  .decrementQuantity(item.product.id ?? 0),
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
          ],
        );
      }),
    );
  }
}
