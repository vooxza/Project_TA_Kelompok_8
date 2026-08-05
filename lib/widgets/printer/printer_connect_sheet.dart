import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import '../../core/services/thermal_print_service.dart';
import '../../core/theme/app_colors.dart';

/// Bottom sheet universal untuk menghubungkan printer thermal.
/// Mendukung USB, Bluetooth (BLE), dan Jaringan (WiFi).
void showPrinterConnectSheet(BuildContext context) {
  ThermalPrintService.init();
  Get.bottomSheet(
    const _PrinterConnectSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _PrinterConnectSheet extends StatefulWidget {
  const _PrinterConnectSheet();

  @override
  State<_PrinterConnectSheet> createState() => _PrinterConnectSheetState();
}

class _PrinterConnectSheetState extends State<_PrinterConnectSheet> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController(
    text: '9100',
  );

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    await ThermalPrintService.scanPrinters();
    if (mounted) setState(() {});
  }

  Future<void> _connectDevice(Printer device) async {
    final ok = await ThermalPrintService.connectDevice(device);
    _showResult(ok, '${device.name} berhasil terhubung');
  }

  Future<void> _connectNetwork([String? hostOverride, int? portOverride]) async {
    final host = (hostOverride ?? _hostController.text.trim());
    final port = portOverride ?? (int.tryParse(_portController.text.trim()) ?? 9100);
    if (host.isEmpty) {
      _showResult(false, 'Masukkan alamat IP printer terlebih dahulu');
      return;
    }
    final ok = await ThermalPrintService.connectNetwork(host, port);
    _showResult(ok, 'Printer jaringan $host:$port berhasil terhubung');
  }

  Future<void> _disconnect() async {
    await ThermalPrintService.disconnectPrinter();
    if (mounted) setState(() {});
  }

  void _showResult(bool ok, String successMessage) {
    if (mounted) setState(() {});
    Get.snackbar(
      'Printer',
      ok ? successMessage : 'Gagal terhubung ke printer',
      snackPosition: SnackPosition.TOP,
      backgroundColor: ok ? AppColors.success : AppColors.error,
      colorText: AppColors.textWhite,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pengaturan Printer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Hubungkan printer thermal untuk mencetak nota',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 20),

              // Status koneksi
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ThermalPrintService.isConnected.value
                        ? AppColors.successLight
                        : AppColors.bgSurfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ThermalPrintService.isConnected.value
                          ? AppColors.success.withOpacity(0.3)
                          : AppColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        ThermalPrintService.isConnected.value
                            ? Icons.check_circle_rounded
                            : Icons.error_outline_rounded,
                        color: ThermalPrintService.isConnected.value
                            ? AppColors.success
                            : AppColors.textLight,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ThermalPrintService.isConnected.value
                                  ? 'Terhubung'
                                  : 'Belum terhubung',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (ThermalPrintService.isConnected.value) ...[
                              const SizedBox(height: 2),
                              Text(
                                ThermalPrintService.connectionName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (ThermalPrintService.isConnected.value)
                        GestureDetector(
                          onTap: _disconnect,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Putus',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= USB / Bluetooth =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'USB / Bluetooth',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: ThermalPrintService.isScanning.value
                          ? null
                          : _startScan,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ThermalPrintService.isScanning.value
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Cari Printer',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Daftar device hasil scan
              Obx(() {
                final devices = ThermalPrintService.availableDevices;
                if (ThermalPrintService.isScanning.value && devices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primaryRed,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Mencari printer...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (devices.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Tidak ada printer ditemukan. '
                      'Pastikan printer USB terpasang & Bluetooth menyala.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final device in devices)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _DeviceTile(
                          device: device,
                          onTap: () => _connectDevice(device),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ================= Emulator / via Laptop =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accentGoldSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.accentGold.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.laptop_rounded,
                          color: AppColors.accentGold,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Emulator / via Laptop',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Jalankan tool/printer_relay.dart di laptop, '
                      'lalu klik tombol di bawah ini.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () => _connectNetwork('10.0.2.2', 9101),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.cast_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Hubungkan Printer di Laptop',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= Jaringan / WiFi =================
              const Text(
                'Printer Jaringan (WiFi)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Untuk printer ESC/POS yang terhubung ke jaringan',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _NetField(
                      controller: _hostController,
                      hint: 'Alamat IP, contoh: 192.168.1.100',
                      keyboardType: TextInputType.url,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _NetField(
                      controller: _portController,
                      hint: 'Port',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _connectNetwork,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Hubungkan ke Printer Jaringan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final Printer device;
  final VoidCallback onTap;

  const _DeviceTile({required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUsb = device.connectionType == ConnectionType.USB;
    final connected = device.isConnected == true;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: connected ? AppColors.successLight : AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: connected
                ? AppColors.success.withOpacity(0.3)
                : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isUsb ? AppColors.info : AppColors.accentGold)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUsb ? Icons.usb_rounded : Icons.bluetooth_rounded,
                color: isUsb ? AppColors.info : AppColors.accentGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name ?? 'Printer',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUsb ? 'USB · ${device.vendorId}' : 'Bluetooth · ${device.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              connected
                  ? Icons.check_circle_rounded
                  : Icons.link_rounded,
              color: connected ? AppColors.success : AppColors.textMedium,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _NetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _NetField({
    required this.controller,
    required this.hint,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppColors.bgSurfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
      ),
    );
  }
}
