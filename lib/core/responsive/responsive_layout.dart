import 'package:flutter/material.dart';

/// Widget layout utama yang menentukan versi mana yang ditampilkan
/// (mobile atau widescreen) berdasarkan lebar layar saat ini.
///
/// Cara pakai di tiap halaman:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return const ResponsiveLayout(
///     mobile: MenuPageMobile(),
///     wide: MenuPageWide(),
///   );
/// }
/// ```
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget wide;

  /// Lebar minimum (dp) supaya dianggap "wide" (tablet/desktop).
  /// Di bawah nilai ini akan menampilkan versi mobile.
  final double breakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.wide,
    this.breakpoint = 800,
  });

  /// Helper kalau butuh cek "apakah sedang wide?" tanpa LayoutBuilder,
  /// misal di dalam widget anak yang butuh tahu ukuran layar.
  static bool isWide(BuildContext context, {double breakpoint = 800}) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return wide;
        }
        return mobile;
      },
    );
  }
}
