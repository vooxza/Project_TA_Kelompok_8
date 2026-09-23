import 'package:flutter/material.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';

/// Kartu QRIS untuk halaman Pembayaran.
///
/// Menampilkan QRIS statis milik warung dari aset lokal
/// (`assets/images/qris_soto.jpeg`) supaya customer tinggal scan.
///
/// `startQrisPayment()` tetap dipanggil di latar belakang supaya order
/// tercatat ke backend & polling status pembayaran (yang mengaktifkan
/// tombol "Konfirmasi Pembayaran") tetap berjalan seperti sebelumnya.
class QrisImageBox extends StatefulWidget {
  final CartController controller;
  const QrisImageBox({super.key, required this.controller});

  @override
  State<QrisImageBox> createState() => _QrisImageBoxState();
}

class _QrisImageBoxState extends State<QrisImageBox> {
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

  @override
  Widget build(BuildContext context) {
    // Gambar qris_soto.jpeg berbentuk potret (1135x1600). Kotak dibuat
    // mengikuti rasio itu (AspectRatio) supaya nggak ada ruang putih
    // kosong di kiri-kanan QR seperti waktu pakai kotak persegi.
    return Container(
      width: 210,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1135 / 1600,
          child: Image.asset(
            'assets/images/qris_soto.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}