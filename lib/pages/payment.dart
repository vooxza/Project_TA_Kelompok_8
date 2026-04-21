import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/bottomnav_controller.dart';
import '../widgets/dialog_button.dart';
import '../theme/colors.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PEMBAYARAN",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _showCancelDialog(cart),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTotal(cart),
            const SizedBox(height: 25),
            const Text(
              "Silahkan Scan Barcode Untuk\nMembayar!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            _buildQRSection(cart),
            const SizedBox(height: 30),
            _buildPayButton(cart),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// TOTAL CARD
  /// =========================
  Widget _buildTotal(CartController cart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          cart.formatRupiah(cart.totalPrice).replaceAll('Rp ', ''),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// =========================
  /// QR SECTION
  /// =========================
  Widget _buildQRSection(CartController cart) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "QRIS",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "SOTO MBOK KERSO",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.qr_code_2, size: 200),
          ),

          const SizedBox(height: 15),

          Text(
            "Total: ${cart.formatRupiah(cart.totalPrice)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text("Meja: ${cart.selectedTable.value ?? '-'}"),
        ],
      ),
    );
  }

  /// =========================
  /// BUTTON BAYAR
  /// =========================
  Widget _buildPayButton(CartController cart) {
    return GestureDetector(
      onTap: () => _showSuccessDialog(cart),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEB6B7C),
          borderRadius: BorderRadius.circular(35),
        ),
        child: const Center(
          child: Text(
            "SAYA SUDAH BAYAR",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// DIALOG BATAL
  /// =========================
  void _showCancelDialog(CartController cart) {
    Get.dialog(
      CustomDialog(
        title: "Batalkan Pesanan?",
        message: "Apakah yakin ingin membatalkan pesanan ini?",
        textCancel: "Tidak",
        textConfirm: "Ya, Batalkan",
        onConfirm: () {
          cart.clearCart();
          final nav = Get.find<BottomNavController>();
          nav.goToForce(0);
        },
      ),
    );
  }

  /// =========================
  /// DIALOG SUCCESS (PAKAI CUSTOM DIALOG)
  /// =========================
void _showSuccessDialog(CartController cart) {
  final nav = Get.find<BottomNavController>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICON SUCCESS
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.textWhite,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Text(
              "PEMBAYARAN BERHASIL",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),

            const SizedBox(height: 10),

            // MESSAGE
            const Text(
              "Silahkan ambil nota untuk melihat pesanan.\n"
              "Jangan lupa cek kembali saat pesanan sampai di meja.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textBlack,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 26),

            // BUTTON
            GestureDetector(
              onTap: () {
                cart.clearCart();
                nav.goToForce(0);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "LANJUT",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
}
