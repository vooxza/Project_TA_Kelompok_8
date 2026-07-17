import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/cart/cart_empty.dart';
import '../../widgets/cart/cart_item_card.dart';
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
                              child: _SummaryPanel(controller: controller),
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

class _SummaryPanel extends StatefulWidget {
  final CartController controller;
  const _SummaryPanel({required this.controller});

  @override
  State<_SummaryPanel> createState() => _SummaryPanelState();
}

class _SummaryPanelState extends State<_SummaryPanel> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller.selectedTable.value ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          // Atas nama
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    size: 18, color: AppColors.textLight),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) => widget.controller.selectedTable
                        .value = value.trim().isEmpty ? null : value.trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      hintText: 'Atas Nama',
                      hintStyle: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  widget.controller.formatRupiah(widget.controller.totalPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryRed,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (widget.controller.selectedTable.value == null ||
                    widget.controller.selectedTable.value!.trim().isEmpty) {
                  Get.snackbar(
                    'Atas Nama Kosong',
                    'Silakan isi nama terlebih dahulu',
                    backgroundColor: AppColors.warning,
                    colorText: AppColors.textWhite,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                  );
                  return;
                }
                Get.toNamed(AppRoutes.payment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Lanjut Pembayaran',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.textWhite, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
