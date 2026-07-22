import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Bungkus standar untuk halaman versi widescreen: satu kanvas cream penuh
/// (tanpa "kartu" mengambang di atas latar abu-abu, tanpa margin/shadow
/// terpisah). Konten tetap dibatasi lebar maksimumnya ([maxWidth]) supaya
/// tetap enak dibaca di layar yang sangat lebar, tapi tanpa kesan "kotak
/// terpisah" seperti sebelumnya.
///
/// Dipakai oleh semua halaman `pages/wide/*_wide.dart` supaya tampilannya
/// konsisten satu sama lain.
class WidePageContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const WidePageContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding = const EdgeInsets.fromLTRB(32, 28, 32, 28),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
