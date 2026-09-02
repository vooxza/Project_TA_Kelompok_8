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
///
/// Catatan penting BLE:
/// - Koneksi & pengiriman data BLE ditangani langsung via UniversalBle
///   (di-export oleh plugin), TIDAK lewat `FlutterThermalPrinter.printData`
///   karena method bawaan plugin hanya mencari properti `write` dan tidak
///   pernah mencetak untuk printer yang hanya mendukung Write Without Response.
/// - Print diberi batas waktu (timeout) supaya tidak pernah menggantung UI.
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

  // Cache hasil discover BLE (karakteristik tulis) agar tidak perlu
  // discover ulang tiap kali print — operasi discover BLE itu lambat &
  // sering bikin koneksi putus kalau diulang-ulang.
  static BleCharacteristic? _bleCacheWriteChar;
  static bool _bleCacheWriteWithoutResponse = false;

  static void _clearBleCache() {
    _bleCacheWriteChar = null;
  }

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
        final ok = await _isDeviceConnected(_connectedDevice!);
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
    _clearBleCache();
    try {
      if (device.connectionType == ConnectionType.USB) {
        // Pada Android, connect() akan memicu popup izin USB
        await _printer.connect(device);
        await Future.delayed(const Duration(milliseconds: 400));
        isConnected.value = await PrinterManager.instance.isConnected(device);
      } else if (device.connectionType == ConnectionType.BLE) {
        isConnected.value = await _connectBle(device);
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

  /// Connect BLE langsung via UniversalBle.
  ///
  /// Tidak memakai `_printer.connect()` dari plugin karena method itu
  /// menunggu 10 detik secara hardcode (penyebab aplikasi terasa lemot).
  static Future<bool> _connectBle(Printer device) async {
    try {
      final address = device.address;
      if (address == null || address.isEmpty) return false;

      // Sudah terhubung → langsung sukses.
      if (await _isBleConnected(device)) return true;

      // Sedang proses koneksi → TUNGGU, jangan connect ulang.
      // Connect ulang saat state masih "connecting" bikin Android
      // membatalkan koneksi yang sedang berjalan → log
      // "Connection Terminated By Local Host" (status 22) → printer putus.
      for (var i = 0; i < 10; i++) {
        final state = await _getBleState(device);
        if (state == BleConnectionState.connected) return true;
        if (state == BleConnectionState.connecting) {
          await Future.delayed(const Duration(milliseconds: 300));
          continue;
        }
        break;
      }
      if (await _isBleConnected(device)) return true;

      // Bersihkan dulu GATT lama yang mungkin masih nyangkut (belum
      // di-close oleh plugin setelah koneksi sempat putus). Kalau tidak
      // dibersihkan, connectGatt yang baru akan MEMBATALKAN koneksi lama
      // → Android mengirim status 22 "Connection Terminated By Local Host"
      // (log cancelOpen() + unregisterApp() + close()).
      try {
        await UniversalBle.disconnect(address)
            .timeout(const Duration(seconds: 2));
      } catch (_) {
        // GATT tidak dikenal / sudah tertutup — abaikan.
      }
      await Future.delayed(const Duration(milliseconds: 200));

      await UniversalBle.connect(address);

      // Tunggu sampai koneksi benar-benar stabil, maksimal ~4 detik.
      for (var i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (await _isBleConnected(device)) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Ambil state koneksi BLE terkini.
  static Future<BleConnectionState> _getBleState(Printer device) async {
    try {
      final address = device.address;
      if (address == null || address.isEmpty) {
        return BleConnectionState.disconnected;
      }
      return await UniversalBle.getConnectionState(address);
    } catch (_) {
      return BleConnectionState.disconnected;
    }
  }

  /// Cek koneksi BLE yang SEBENARNYA (bukan flag stale dari hasil scan).
  static Future<bool> _isBleConnected(Printer device) async {
    try {
      final address = device.address;
      if (address == null || address.isEmpty) return false;
      final state = await UniversalBle.getConnectionState(address);
      return state == BleConnectionState.connected;
    } catch (_) {
      return false;
    }
  }

  /// Cek koneksi device sesuai jenis koneksinya.
  static Future<bool> _isDeviceConnected(Printer device) async {
    try {
      if (device.connectionType == ConnectionType.BLE) {
        return _isBleConnected(device);
      }
      return await PrinterManager.instance.isConnected(device);
    } catch (_) {
      return false;
    }
  }

  /// Connect ke printer jaringan (ESC/POS over TCP, default port 9100).
  static Future<bool> connectNetwork(String host, int port) async {
    _clearBleCache();
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
    _clearBleCache();
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
      isConnected.value = false;
      return false;
    }

    // Device USB / BLE yang sudah aktif
    if (_connectedDevice != null) {
      if (await _isDeviceConnected(_connectedDevice!)) {
        isConnected.value = true;
        return true;
      }
      isConnected.value = false;
    }

    // Reconnect printer terakhir
    if (await _restoreSavedConnection()) return true;

    // JANGAN auto-scan di sini: scan BLE saat print bikin HP lemot
    // dan malah mengganggu koneksi printer yang sedang aktif.
    isConnected.value = false;
    return false;
  }

  /// Print nota pesanan ke printer yang aktif.
  ///
  /// Aman dipanggil dari mana saja: method ini punya batas waktu (timeout)
  /// sehingga TIDAK akan menggantung UI pembayaran walau printer BLE
  /// bermasalah. Setiap kegagalan selalu ditampilkan lewat snackbar.
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
      await _printNotaInternal(
        invoiceNumber: invoiceNumber,
        customerName: customerName,
        items: items,
        totalPrice: totalPrice,
        cashGiven: cashGiven,
        change: change,
        paymentMethod: paymentMethod,
      ).timeout(const Duration(seconds: 12));
    } on TimeoutException {
      _showSnackbar(
        'Gagal Print',
        'Printer tidak merespons, cek koneksi printer',
        isError: true,
      );
    } catch (e) {
      _showSnackbar(
        'Gagal Print',
        'Error: $e',
        isError: true,
      );
    }
  }

  static Future<void> _printNotaInternal({
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

      // Catatan: generator.cut() menyisipkan 5 baris kosong otomatis yang
      // bikin gap kegedean. Jadi dipakai potong manual: feed 1 baris +
      // GS V 0 (full cut) supaya rapat dengan teks terakhir.
      bytes += generator.emptyLines(1);
      bytes += [0x1D, 0x56, 0x30]; // GS V 0 → full cut

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
      final net = FlutterThermalPrinterNetwork(
        _networkHost!,
        port: _networkPort,
      );
      final result = await net.printTicket(bytes);
      if (result != NetworkPrintResult.success) {
        throw Exception(result.msg);
      }
      return;
    }

    if (_connectedDevice == null) {
      throw Exception('Printer belum dipilih');
    }

    // BLE dikirim manual (per-chunk + jeda) supaya buffer printer tidak
    // penuh sehingga printer tidak reset/putus koneksi saat print nota.
    if (_connectedDevice!.connectionType == ConnectionType.BLE) {
      await _sendBytesBle(_connectedDevice!, bytes);
      return;
    }

    await _printer.printData(_connectedDevice!, Uint8List.fromList(bytes));
  }

  /// Kirim data BLE dalam potongan kecil dengan jeda antar-potongan.
  /// Kalau koneksi putus / write gagal di tengah jalan, koneksi dibersihkan
  /// lalu seluruh kiriman dicoba ulang sekali.
  static Future<void> _sendBytesBle(Printer device, List<int> bytes) async {
    final address = device.address;
    if (address == null || address.isEmpty) {
      throw Exception('Alamat Bluetooth printer kosong');
    }

    const chunkSize = 20;

    for (var attempt = 0; ; attempt++) {
      if (!await _isBleConnected(device)) {
        final ok = await _connectBle(device);
        if (!ok) {
          isConnected.value = false;
          throw Exception('Koneksi Bluetooth putus, silakan coba lagi');
        }
        isConnected.value = true;
        // GATT baru setelah reconnect → cache karakteristik dari koneksi
        // lama (yang sudah di-close) TIDAK valid lagi. Wajib dibersihkan
        // supaya tidak menulis ke karakteristik yang sudah mati.
        _clearBleCache();
        // Jeda singkat agar GATT benar-benar siap menerima operasi
        // (discover/write langsung setelah connect sering bikin putus).
        await Future.delayed(const Duration(milliseconds: 400));
      }

      try {
        await _writeBleChunks(device, bytes, chunkSize);
        return;
      } catch (_) {
        // Koneksi bermasalah di tengah kirim → putuskan paksa lalu coba
        // sekali lagi. Kalau percobaan kedua juga gagal, biarkan error
        // naik supaya muncul "Gagal Print".
        if (attempt >= 1) rethrow;
        _clearBleCache();
        isConnected.value = false;
        try {
          await UniversalBle.disconnect(address)
              .timeout(const Duration(seconds: 2));
        } catch (_) {
          // GATT tidak dikenal / sudah tertutup — abaikan.
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  /// Tulis seluruh byte ke karakteristik BLE dalam potongan kecil.
  static Future<void> _writeBleChunks(
    Printer device,
    List<int> bytes,
    int chunkSize,
  ) async {
    // Ambil karakteristik tulis (pakai cache kalau printer masih sama).
    BleCharacteristic? writeCharacteristic = _bleCacheWriteChar;
    var writeWithoutResponse = _bleCacheWriteWithoutResponse;

    if (writeCharacteristic == null) {
      final services = await device.discoverServices();

      // Prioritas 1: Write Without Response. Printer thermal BLE murah
      // (MP58 dll) hampir selalu hanya andalkan ini. Kalau dipaksa write
      // dengan response, printer tidak mengirim ACK → write menggantung
      // → timeout & koneksi diputus Android.
      for (final service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.properties.contains(
            CharacteristicProperty.writeWithoutResponse,
          )) {
            writeCharacteristic = characteristic;
            writeWithoutResponse = true;
            break;
          }
        }
        if (writeCharacteristic != null) break;
      }

      // Prioritas 2: fallback ke write biasa kalau tidak ada W-W-R.
      if (writeCharacteristic == null) {
        for (final service in services) {
          for (final characteristic in service.characteristics) {
            if (characteristic.properties.contains(
              CharacteristicProperty.write,
            )) {
              writeCharacteristic = characteristic;
              break;
            }
          }
          if (writeCharacteristic != null) break;
        }
      }

      if (writeCharacteristic == null) {
        throw Exception(
          'Karakteristik tulis tidak ditemukan. '
          'Printer ini kemungkinan bukan Bluetooth BLE (ESC/POS). '
          'Coba gunakan koneksi USB / WiFi.',
        );
      }

      _bleCacheWriteChar = writeCharacteristic;
      _bleCacheWriteWithoutResponse = writeWithoutResponse;
    }

    // Ukuran chunk aman: TANPA negosiasi MTU. RPP02N & printer BLE murah
    // lainnya sering putus koneksi (status 22) saat diminta MTU besar.
    // Tanpa requestMtu, MTU default Android = 23 → data per write = 20 byte.
    // Sedikit lebih lambat tapi jauh lebih stabil.
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final end = i + chunkSize > bytes.length ? bytes.length : i + chunkSize;

      final write = writeCharacteristic.write(
        Uint8List.fromList(bytes.sublist(i, end)),
        withResponse: !writeWithoutResponse,
      );

      // Timeout dipasang di semua write. Write dengan response bisa
      // menggantung kalau printer tidak membalas ACK, dan write tanpa
      // response juga bisa hang kalau printer sedang sibuk — keduanya
      // bikin tampil "Gagal Print". Batasi agar tidak menunggu selamanya.
      await write.timeout(const Duration(milliseconds: 3000));

      await Future.delayed(const Duration(milliseconds: 30));
    }
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
    final isWhole = amount % 1 == 0;
    final raw = isWhole
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2).replaceAll('.', ',');
    final parts = raw.split(',');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final intPart = parts[0].replaceAllMapped(reg, (m) => '${m[1]}.');
    return 'Rp $intPart${parts.length > 1 ? ',${parts[1]}' : ''}';
  }
}
