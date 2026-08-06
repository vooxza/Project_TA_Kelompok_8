import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';

/// Kartu status pembayaran QRIS yang diambil dari payment gateway lewat
/// `CartController.startQrisPayment()`. Dipakai bareng oleh
/// [QRSectionMobile] dan [QRSectionWide] supaya logic
/// fetch/loading/error-nya nggak ditulis dua kali.
///
/// PENTING: sesuai kontrak backend saat ini, `controller.qrisUrl` isinya
/// URL HALAMAN PEMBAYARAN Midtrans (Snap redirection page) — bukan URL
/// gambar QR. Makanya di sini kita nggak pakai Image.network, tapi buka
/// halamannya lewat url_launcher. Di halaman itu customer bisa pilih
/// GoPay QRIS (atau metode lain) dan bakal muncul QR code beneran buat
/// discan. Setelah bayar, cashier tinggal klik "Konfirmasi Pembayaran"
/// yang bakal polling status ke backend.
class QrisImageBox extends StatefulWidget {
  final CartController controller;
  const QrisImageBox({super.key, required this.controller});

  @override
  State<QrisImageBox> createState() => _QrisImageBoxState();
}

class _QrisImageBoxState extends State<QrisImageBox> {
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    // PENTING: jangan panggil langsung di sini. initState() widget ini
    // dipicu SAAT parent (QRSectionMobile/Wide) masih dalam proses build,
    // dan startQrisPayment() langsung mengubah qrisLoading.value secara
    // synchronous (sebelum baris `await` pertama) — itu bikin Obx lain
    // mencoba rebuild di tengah build phase yang sedang berjalan
    // ("setState() or markNeedsBuild() called during build"). Makanya
    // ditunda ke akhir frame ini pakai addPostFrameCallback, supaya jalan
    // SETELAH build selesai.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.controller.startQrisPayment();
      }
    });
  }

  Future<void> _openPaymentPage(String url) async {
    setState(() => _opening = true);
    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        Get.snackbar(
          'Gagal Membuka',
          'Tidak bisa membuka halaman pembayaran.',
          backgroundColor: AppColors.snackbarError,
          colorText: AppColors.textWhite,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 2),
      ),
      child: Obx(() {
        if (widget.controller.qrisLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryRed,
              strokeWidth: 2.5,
            ),
          );
        }

        final error = widget.controller.qrisError.value;
        if (error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 32),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    widget.controller.qrisError.value = null;
                    widget.controller.startQrisPayment();
                  },
                  child: const Text(
                    'Coba lagi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final url = widget.controller.qrisUrl.value;
        if (url == null) {
          return const Center(
            child: Icon(Icons.qr_code_2_rounded,
                size: 120, color: AppColors.textDark),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_2_rounded,
                size: 64, color: AppColors.primaryRed),
            const SizedBox(height: 12),
            const Text(
              'Halaman pembayaran siap.\nPilih GoPay QRIS untuk memunculkan QR.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _opening ? null : () => _openPaymentPage(url),
                icon: _opening
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text(
                  'Buka Halaman Pembayaran',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}