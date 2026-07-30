import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

class ThermalPrintService {
  static final FlutterThermalPrinter _printer = FlutterThermalPrinter.instance;

  // ✅ Observable status koneksi
  static final RxBool isConnected = false.obs;

  // Device printer yang sedang terhubung
  static Printer? _connectedDevice;

  /// Cek status koneksi printer
  static Future<void> checkConnection() async {
    try {
      isConnected.value = _connectedDevice?.isConnected ?? false;
    } catch (_) {
      isConnected.value = false;
    }
  }

  /// Cari & connect ke printer USB
  static Future<bool> connectToPrinter() async {
    try {
      final completer = Completer<bool>();
      late final StreamSubscription sub;

      // Mulai scan printer USB
      _printer.getPrinters(connectionTypes: [ConnectionType.USB]);

      sub = _printer.devicesStream.listen((devices) async {
        if (devices.isEmpty) return;

        // Cari NuPrint MP58 Lite, fallback ke device pertama
        Printer? target;
        for (final d in devices) {
          final name = (d.name ?? '').toLowerCase();
          if (name.contains('nuprint') ||
              name.contains('mp58') ||
              name.contains('printer') ||
              name.contains('pos') ||
              name.contains('thermal')) {
            target = d;
            break;
          }
        }
        target ??= devices.first;

        try {
          await _printer.connect(target);
          _connectedDevice = target;
          isConnected.value = true;
          if (!completer.isCompleted) completer.complete(true);
        } catch (e) {
          isConnected.value = false;
          if (!completer.isCompleted) completer.complete(false);
        } finally {
          await sub.cancel();
        }
      });

      // Timeout kalau tidak ada device ketemu dalam 5 detik
      Future.delayed(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          sub.cancel();
        }
      });

      final success = await completer.future;

      if (!success) {
        Get.snackbar(
          'Printer Tidak Ditemukan',
          'Pastikan NuPrint MP58 Lite sudah terhubung via kabel USB',
          snackPosition: SnackPosition.TOP,
        );
        isConnected.value = false;
      }

      return success;
    } catch (e) {
      isConnected.value = false;
      Get.snackbar(
        'Gagal Connect Printer',
        'Error: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  /// Disconnect printer
  static Future<void> disconnectPrinter() async {
    try {
      if (_connectedDevice != null) {
        await _printer.disconnect(_connectedDevice!);
      }
      _connectedDevice = null;
      isConnected.value = false;
    } catch (_) {
      isConnected.value = false;
    }
  }

  /// Print nota pesanan
  static Future<void> printNota({
    required String invoiceNumber,
    required String customerName,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
    double? cashGiven,
    double? change,
    required String paymentMethod,
  }) async {
    try {
      final connected = await connectToPrinter();
      if (!connected || _connectedDevice == null) return;

      final now = DateTime.now();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      final dateStr =
          '${now.day} ${months[now.month - 1]} ${now.year} '
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      final profile = await CapabilityProfile.load();
      // Ganti PaperSize.mm58 jika kertas printer kamu 58mm
      final generator = Generator(PaperSize.mm80, profile);

      List<int> bytes = [];

      bytes += generator.text(
        'WARUNG SOTO MBOK KERSO',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.text(
        'Jl. Contoh No. 1, Semarang',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(
        '--------------------------------',
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator.row([
        PosColumn(text: 'Invoice', width: 4, styles: const PosStyles(bold: true)),
        PosColumn(text: invoiceNumber, width: 8, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Pemesan', width: 4, styles: const PosStyles(bold: true)),
        PosColumn(text: customerName, width: 8, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Tanggal', width: 4),
        PosColumn(text: dateStr, width: 8, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.text(
        '--------------------------------',
        styles: const PosStyles(align: PosAlign.center),
      );

      for (final item in items) {
        final name = item['name'].toString();
        final qty = item['quantity'] as int;
        final price = item['price'] as double;
        final subtotal = _formatRupiah(price * qty);

        bytes += generator.text('$qty x $name');
        bytes += generator.row([
          PosColumn(text: '  @${_formatRupiah(price)}', width: 6),
          PosColumn(text: subtotal, width: 6, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      bytes += generator.text(
        '--------------------------------',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.row([
        PosColumn(text: 'TOTAL', width: 4, styles: const PosStyles(bold: true)),
        PosColumn(
          text: _formatRupiah(totalPrice),
          width: 8,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      if (paymentMethod == 'tunai' && cashGiven != null && change != null) {
        bytes += generator.row([
          PosColumn(text: 'Bayar', width: 4),
          PosColumn(text: _formatRupiah(cashGiven), width: 8, styles: const PosStyles(align: PosAlign.right)),
        ]);
        bytes += generator.row([
          PosColumn(text: 'Kembali', width: 4),
          PosColumn(text: _formatRupiah(change), width: 8, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      bytes += generator.text(
        '--------------------------------',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(
        'Pembayaran: ${paymentMethod.toUpperCase()}',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.emptyLines(1);
      bytes += generator.text(
        'Terima kasih sudah makan',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(
        'di Warung Soto Mbok Kerso!',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.emptyLines(3);
      bytes += generator.cut();

      await _printer.printData(_connectedDevice!, Uint8List.fromList(bytes));
    } catch (e) {
      Get.snackbar(
        'Gagal Print',
        'Error: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  static String _formatRupiah(double amount) {
    final result = amount.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${result.replaceAllMapped(reg, (m) => '${m[1]}.')}';
  }
}