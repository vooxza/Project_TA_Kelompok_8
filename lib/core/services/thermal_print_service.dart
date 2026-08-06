import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/Windows/printers_data.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/network/network_print_result.dart';
import 'package:flutter_thermal_printer/printer_manager.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:win32/win32.dart';

/// Service printer thermal universal.
///
/// Mendukung 3 jenis koneksi sekaligus:
/// - USB   (printer thermal kabel)
/// - Bluetooth / BLE (printer thermal wireless)
/// - Network / WiFi (printer ESC/POS via TCP port 9100)
///
/// Pilihan printer terakhir disimpan otomatis sehingga saat print nota
/// berikutnya service ini akan mencoba reconnect dengan sendirinya.
class ThermalPrintService {
  static final FlutterThermalPrinter _printer = FlutterThermalPrinter.instance;

  /// Status koneksi printer (observable)
  static final RxBool isConnected = false.obs;

  /// Status sedang scan printer
  static final RxBool isScanning = false.obs;

  /// Daftar printer USB/BLE yang ditemukan hasil scan
  static final RxList<Printer> availableDevices = <Printer>[].obs;

  static const String _storageKey = 'thermal_print_settings';

  static Printer? _connectedDevice;
  static String? _networkHost;
  static int _networkPort = 9100;

  static Map<String, dynamic>? _savedDeviceData;
  static String? _savedConnectionType;

  static StreamSubscription<List<Printer>>? _scanSub;

  static bool _loaded = false;

  static String get connectionName {
    if (_connectedDevice?.name != null) return _connectedDevice!.name!;
    if (_networkHost != null && _networkHost!.isNotEmpty) {
      return '$_networkHost:$_networkPort';
    }
    return '-';
  }

  /// Panggil sekali di awal aplikasi agar setting printer terbaca.
  static void init() {
    _loadSettings();
  }

  static void _loadSettings() {
    try {
      if (_loaded) return;
      _loaded = true;
      final box = GetStorage();
      final raw = box.read<String>(_storageKey);
      if (raw == null || raw.isEmpty) return;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      _savedDeviceData =
          (data['device'] as Map<String, dynamic>?)?.cast<String, dynamic>();
      _savedConnectionType = data['connectionType'] as String?;
      _networkHost = data['networkHost'] as String?;
      _networkPort = (data['networkPort'] as num?)?.toInt() ?? 9100;
    } catch (_) {
      // abaikan, setting tidak valid
    }
  }

  static void _saveSettings() {
    try {
      final box = GetStorage();
      final data = <String, dynamic>{
        'connectionType': _savedConnectionType,
        'device': _savedDeviceData,
        'networkHost': _networkHost,
        'networkPort': _networkPort,
      };
      box.write(_storageKey, jsonEncode(data));
    } catch (_) {
      // abaikan, gagal menyimpan
    }
  }

  /// Cek status koneksi printer yang sedang aktif.
  static Future<void> checkConnection() async {
    _loadSettings();
    try {
      if (_networkHost != null && _networkHost!.isNotEmpty) {
        isConnected.value = true;
        return;
      }
      if (_connectedDevice != null) {
        final ok = await PrinterManager.instance.isConnected(_connectedDevice!);
        if (ok) {
          isConnected.value = true;
          return;
        }
      }
      isConnected.value = false;
    } catch (_) {
      isConnected.value = false;
    }
  }

  /// Scan printer USB & Bluetooth (BLE).
  static Future<void> scanPrinters() async {
    if (isScanning.value) return;
    availableDevices.clear();
    isScanning.value = true;
    try {
      // Windows: langsung ambil printer yang sudah terpasang di laptop,
      // TANPA menunggu hasil scan (lebih andal & cepat).
      if (Platform.isWindows) {
        availableDevices.assignAll(await listInstalledPrinters());
        // tetap scan Bluetooth juga
        _printer.getPrinters(
          refreshDuration: const Duration(seconds: 2),
          connectionTypes: [ConnectionType.BLE],
        );
      } else {
        await _printer.getPrinters(
          refreshDuration: const Duration(seconds: 2),
          connectionTypes: [ConnectionType.USB, ConnectionType.BLE],
        );
      }

      await _scanSub?.cancel();
      _scanSub = _printer.devicesStream.listen((devices) {
        availableDevices.assignAll(_mergeUniqueDevices(
          [...availableDevices, ...devices],
        ));
      });

      await Future.delayed(const Duration(seconds: 3));
    } catch (_) {
      // abaikan error scan
    } finally {
      await _scanSub?.cancel();
      _scanSub = null;
      await _printer.stopScan();
      isScanning.value = false;
    }
  }

  /// Ambil daftar printer yang SUDAH terpasang di Windows (tanpa scan).
  /// Ini sumber utama di laptop: printer terlihat langsung begitu terbuka.
  static Future<List<Printer>> listInstalledPrinters() async {
    if (!Platform.isWindows) return const [];
    try {
      final devices = <Printer>[];
      final names = PrinterNames(PRINTER_ENUM_LOCAL);
      for (final printerName in names.all()) {
        if (printerName.trim().isEmpty) continue;
        devices.add(Printer(
          vendorId: printerName,
          productId: 'N/A',
          name: printerName,
          connectionType: ConnectionType.USB,
          address: printerName,
          isConnected: true,
        ));
      }
      return devices;
    } catch (_) {
      return const [];
    }
  }

  static List<Printer> _mergeUniqueDevices(List<Printer> devices) {
    final seen = <String>{};
    return [
      for (final d in devices)
        if (d.name != null && d.name!.isNotEmpty && seen.add(d.name!)) d,
    ];
  }

  /// Connect ke printer USB / Bluetooth yang dipilih.
  static Future<bool> connectDevice(Printer device) async {
    try {
      if (device.connectionType == ConnectionType.USB) {
        // Pada Android, connect() akan memicu popup izin USB
        await _printer.connect(device);
        await Future.delayed(const Duration(milliseconds: 400));
        isConnected.value = await PrinterManager.instance.isConnected(device);
      } else if (device.connectionType == ConnectionType.BLE) {
        isConnected.value = await _printer.connect(device);
      } else {
        isConnected.value = false;
      }

      if (isConnected.value) {
        _connectedDevice = device;
        _networkHost = null;
        _savedDeviceData = device.toJson();
        _savedConnectionType = device.connectionType?.name;
        _saveSettings();
      }
      return isConnected.value;
    } catch (_) {
      isConnected.value = false;
      return false;
    }
  }

  /// Connect ke printer jaringan (ESC/POS over TCP, default port 9100).
  static Future<bool> connectNetwork(String host, int port) async {
    try {
      final net = FlutterThermalPrinterNetwork(
        host,
        port: port,
        timeout: const Duration(seconds: 3),
      );
      final result = await net.connect();
      await net.disconnect();

      if (result == NetworkPrintResult.success) {
        _connectedDevice = null;
        _savedDeviceData = null;
        _savedConnectionType = ConnectionType.NETWORK.name;
        _networkHost = host;
        _networkPort = port;
        isConnected.value = true;
        _saveSettings();
        return true;
      }
      isConnected.value = false;
      return false;
    } catch (_) {
      isConnected.value = false;
      return false;
    }
  }

  /// Putus koneksi printer aktif.
  static Future<void> disconnectPrinter() async {
    try {
      if (_connectedDevice != null) {
        await _printer.disconnect(_connectedDevice!);
      }
      _connectedDevice = null;
      _networkHost = null;
      isConnected.value = false;
      _saveSettings();
    } catch (_) {
      _connectedDevice = null;
      isConnected.value = false;
    }
  }

  /// Backward-compatible: cari & connect printer (dipakai juga untuk auto-connect).
  static Future<bool> connectToPrinter() async {
    _loadSettings();
    if (await _restoreSavedConnection()) return true;
    return _autoDetectAndConnect();
  }

  /// Coba kembalikan koneksi ke printer yang terakhir dipilih.
  static Future<bool> _restoreSavedConnection() async {
    if (_savedConnectionType == ConnectionType.NETWORK.name) {
      if (_networkHost != null && _networkHost!.isNotEmpty) {
        return connectNetwork(_networkHost!, _networkPort);
      }
      return false;
    }

    if (_savedDeviceData == null) return false;
    try {
      final device = Printer.fromJson(_savedDeviceData!);
      return connectDevice(device);
    } catch (_) {
      return false;
    }
  }

  /// Auto-detect: scan USB + BLE lalu connect ke printer pertama yang cocok.
  static Future<bool> _autoDetectAndConnect() async {
    // Windows: langsung pakai printer yang sudah terpasang di laptop
    if (Platform.isWindows) {
      final installed = await listInstalledPrinters();
      if (installed.isNotEmpty) {
        return connectDevice(installed.first);
      }
    }

    availableDevices.clear();
    final completer = Completer<Printer?>();
    try {
      await _printer.stopScan();
      await _printer.getPrinters(
        refreshDuration: const Duration(seconds: 2),
        connectionTypes: [ConnectionType.USB, ConnectionType.BLE],
      );

      _scanSub = _printer.devicesStream.listen((devices) {
        availableDevices.assignAll(devices);
        final target = _pickBestPrinter(devices);
        if (target != null && !completer.isCompleted) {
          completer.complete(target);
        }
      });

      // Tunggu maksimal 6 detik
      final timer = Timer(const Duration(seconds: 6), () {
        if (!completer.isCompleted) completer.complete(null);
      });

      final target = await completer.future;
      timer.cancel();

      if (target == null) return false;
      return connectDevice(target);
    } catch (_) {
      return false;
    } finally {
      await _scanSub?.cancel();
      _scanSub = null;
      await _printer.stopScan();
    }
  }

  static Printer? _pickBestPrinter(List<Printer> devices) {
    if (devices.isEmpty) return null;
    const keywords = [
      'printer',
      'pos',
      'thermal',
      'nuprint',
      'mp58',
      'tm-',
      'epson',
      'xprinter',
      '58',
      '80',
    ];
    for (final d in devices) {
      final name = (d.name ?? '').toLowerCase();
      if (keywords.any(name.contains)) return d;
    }
    return devices.first;
  }

  /// Pastikan printer terhubung sebelum print. Reconnect otomatis bila perlu.
  static Future<bool> _ensureConnected() async {
    _loadSettings();

    // Printer jaringan
    if (_networkHost != null && _networkHost!.isNotEmpty) {
      final net = FlutterThermalPrinterNetwork(
        _networkHost!,
        port: _networkPort,
        timeout: const Duration(seconds: 3),
      );
      final result = await net.connect();
      await net.disconnect();
      if (result == NetworkPrintResult.success) {
        isConnected.value = true;
        return true;
      }
    }

    // Device USB / BLE yang sudah aktif
    if (_connectedDevice != null) {
      final ok = await PrinterManager.instance.isConnected(_connectedDevice!);
      if (ok) {
        isConnected.value = true;
        return true;
      }
    }

    // Reconnect printer terakhir
    if (await _restoreSavedConnection()) return true;

    // Terakhir: coba auto-detect
    return _autoDetectAndConnect();
  }

  /// Print nota pesanan ke printer yang aktif.
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
      final connected = await _ensureConnected();

      if (!connected) {
        _showSnackbar(
          'Printer Tidak Terhubung',
          'Hubungkan printer terlebih dahulu lewat ikon printer',
          isError: true,
        );
        return;
      }

      final now = DateTime.now();

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      final dateStr =
          '${now.day} ${months[now.month - 1]} ${now.year} '
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      final profile = await CapabilityProfile.load();

      // MP58 = 58 mm
      final generator = Generator(PaperSize.mm58, profile);

      List<int> bytes = [];

      String formatLine(String left, String right) {
        const totalWidth = 32;

        final spaces = totalWidth - left.length - right.length;

        if (spaces <= 0) {
          return '$left $right';
        }

        return left + (' ' * spaces) + right;
      }

      bytes += generator.text(
        'WARUNG SOTO MBOK KERSO',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      );

      bytes += generator.text(
        'Jl. Contoh No. 1, Semarang',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.hr();

      bytes += generator.text(
        formatLine('Invoice', invoiceNumber),
        styles: const PosStyles(
          bold: true,
        ),
      );

      bytes += generator.text(
        formatLine('Pemesan', customerName),
      );

      bytes += generator.text(
        formatLine('Tanggal', dateStr),
      );

      bytes += generator.hr();

      for (final item in items) {
        final name = item['name'].toString();
        final qty = item['quantity'] as int;
        final price = item['price'] as double;

        bytes += generator.text(
          '$qty x $name',
        );

        bytes += generator.text(
          formatLine(
            '@${_formatRupiah(price)}',
            _formatRupiah(price * qty),
          ),
        );
      }

      bytes += generator.hr();

      bytes += generator.text(
        formatLine(
          'TOTAL',
          _formatRupiah(totalPrice),
        ),
        styles: const PosStyles(
          bold: true,
        ),
      );

      if (paymentMethod == 'tunai' &&
          cashGiven != null &&
          change != null) {
        bytes += generator.text(
          formatLine(
            'Bayar',
            _formatRupiah(cashGiven),
          ),
        );

        bytes += generator.text(
          formatLine(
            'Kembali',
            _formatRupiah(change),
          ),
        );
      }

      bytes += generator.hr();

      bytes += generator.text(
        'Pembayaran: ${paymentMethod.toUpperCase()}',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.emptyLines(1);

      bytes += generator.text(
        'Terima kasih sudah makan',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.text(
        'di Warung Soto Mbok Kerso!',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.emptyLines(3);

      bytes += generator.cut();

      await _sendBytes(bytes);
    } catch (e) {
      _showSnackbar(
        'Gagal Print',
        'Error: $e',
        isError: true,
      );
    }
  }

  /// Kirim data ESC/POS sesuai jenis koneksi yang aktif.
  static Future<void> _sendBytes(List<int> bytes) async {
    if (_networkHost != null && _networkHost!.isNotEmpty) {
      final net = FlutterThermalPrinterNetwork(_networkHost!, port: _networkPort);
      final result = await net.printTicket(bytes);
      if (result != NetworkPrintResult.success) {
        throw Exception(result.msg);
      }
      return;
    }

    if (_connectedDevice == null) {
      throw Exception('Printer belum dipilih');
    }
    await _printer.printData(_connectedDevice!, Uint8List.fromList(bytes));
  }

  static void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? const Color(0xFFD32F2F) : const Color(0xFF2D8B4E),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static String _formatRupiah(double amount) {
    final result = amount.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${result.replaceAllMapped(reg, (m) => '${m[1]}.')}';
  }
}
