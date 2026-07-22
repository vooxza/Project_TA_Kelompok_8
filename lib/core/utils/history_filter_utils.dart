import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_colors.dart';

/// Kumpulan fungsi murni (pure) untuk memfilter & memformat data Riwayat.
/// Dipakai bersama oleh `HistoryPageMobile` dan `HistoryPageWide` supaya
/// logikanya tidak perlu ditulis dua kali di kedua file.
class HistoryFilterUtils {
  HistoryFilterUtils._();

  static const monthNamesLong = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  static const monthNamesShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  static bool isSameDate(String? isoDate, DateTime target) {
    if (isoDate == null) return false;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return dt.year == target.year &&
          dt.month == target.month &&
          dt.day == target.day;
    } catch (_) {
      return false;
    }
  }

  static bool isSameMonth(String? isoDate, DateTime target) {
    if (isoDate == null) return false;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return dt.year == target.year && dt.month == target.month;
    } catch (_) {
      return false;
    }
  }

  static String formatDateLabel(DateTime date) {
    return '${date.day} ${monthNamesShort[date.month - 1]} ${date.year}';
  }

  static String formatMonthLabel(DateTime date) {
    return '${monthNamesLong[date.month - 1]} ${date.year}';
  }

  /// Daftar order pada [controller.orderList] yang sudah disaring sesuai
  /// filter tanggal/bulan yang sedang aktif (kalau ada).
  static List getFilteredOrders(HistoryController controller) {
    return controller.orderList.where((order) {
      if (controller.selectedDate.value != null) {
        return isSameDate(
            order['created_at']?.toString(), controller.selectedDate.value!);
      }
      if (controller.selectedMonthFilter.value != null) {
        return isSameMonth(
            order['created_at']?.toString(),
            controller.selectedMonthFilter.value!);
      }
      return true;
    }).toList();
  }

  /// Tanggal & bulan unik dari seluruh order, terurut terbaru dulu.
  /// Dipakai untuk mengisi pilihan di [HistoryFilterSheet].
  static (List<DateTime> dates, List<DateTime> months) uniqueDatesAndMonths(
      HistoryController controller) {
    final allDates = controller.orderList
        .map((o) {
          try {
            return DateTime.parse(o['created_at'].toString()).toLocal();
          } catch (_) {
            return null;
          }
        })
        .whereType<DateTime>()
        .map((dt) => DateTime(dt.year, dt.month, dt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final uniqueMonths = allDates
        .map((d) => DateTime(d.year, d.month))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    return (allDates, uniqueMonths);
  }

  /// Label periode aktif ("12 Jan 2026" / "Januari 2026") untuk dipakai
  /// sebagai judul laporan PDF, atau null kalau tidak ada filter aktif.
  static String? activePeriodLabel(HistoryController controller) {
    if (controller.selectedDate.value != null) {
      return formatDateLabel(controller.selectedDate.value!);
    }
    if (controller.selectedMonthFilter.value != null) {
      return formatMonthLabel(controller.selectedMonthFilter.value!);
    }
    return null;
  }
  /// Ekspor daftar pesanan yang SEDANG TAMPIL (sudah kena filter
  /// tanggal/bulan kalau ada) jadi PDF laporan penjualan. Dipakai bersama
  /// oleh HistoryPageMobile & HistoryPageWide (khusus Admin).
  static Future<void> exportPdf(HistoryController controller) async {
    final orders = getFilteredOrders(controller);
    final periodLabel = activePeriodLabel(controller);

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      ),
      barrierDismissible: false,
    );
    try {
      await PdfReportService.previewSalesReport(
        orders: orders,
        periodLabel: periodLabel,
      );
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }
}
