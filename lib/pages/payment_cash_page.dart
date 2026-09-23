import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../controllers/cart_controller.dart';
import '../core/services/thermal_print_service.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

class PaymentCashPage extends StatefulWidget {
  const PaymentCashPage({super.key});

  @override
  State<PaymentCashPage> createState() => _PaymentCashPageState();
}

class _PaymentCashPageState extends State<PaymentCashPage> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController _cashController = TextEditingController();
  double _cashGiven = 0;

  double get _totalPrice => cartController.totalPrice;
  double get _change => _cashGiven - _totalPrice;
  bool get _isEnough => _cashGiven >= _totalPrice;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  String _formatRupiah(double amount) => cartController.formatRupiah(amount);

  String _formatPlain(int amount) {
    final raw = amount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return raw.replaceAllMapped(reg, (m) => '${m[1]}.');
  }

  void _onCashChanged(String value) {
    final normalized = value.replaceAll('.', '').replaceAll(',', '.');
    setState(() => _cashGiven = double.tryParse(normalized) ?? 0);
  }

  Future<void> _onConfirm() async {
    if (!_isEnough) {
      Get.snackbar(
        'Uang Kurang',
        'Uang yang diberikan tidak cukup',
        backgroundColor: AppColors.error,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    // Simpan data cart sebelum di-clear
    final items = cartController.cartItems.map((item) => {
      'name': item.product.name,
      'quantity': item.quantity.value,
      'price': item.product.price,
    }).toList();
    final customerName = cartController.selectedTable.value ?? '-';
    final total = cartController.totalPrice;
    final cashGiven = _cashGiven;
    final change = _change;

    final success = await cartController.checkout(0);
    if (!success) return;

    // ✅ Dialog sukses langsung tampil, print nota jalan di background
    // (printNota punya timeout sendiri, tidak akan menggantung UI).
    _showSuccessDialog(change);
    ThermalPrintService.printNota(
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      items: items,
      totalPrice: total,
      cashGiven: cashGiven,
      change: change,
      paymentMethod: 'tunai',
    );
  }

  void _showSuccessDialog(double change) {
    final nav = Get.find<BottomNavController>();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pembayaran\nBerhasil!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kembalian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      _formatRupiah(change),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nota sedang dicetak...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textLight,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    cartController.clearCart();
                    Get.back();
                    Get.offAllNamed(AppRoutes.main);
                    nav.goToForce(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Menu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textWhite,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pembayaran Tunai',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...cartController.cartItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity.value}x',
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Text(
                            _formatRupiah(
                              item.product.price * item.quantity.value,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24, color: AppColors.divider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        _formatRupiah(_totalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uang yang Diberikan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Rp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cashController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,]'),
                              ),
                              _CurrencyInputFormatter(),
                            ],
                            onChanged: _onCashChanged,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 18,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nominal Cepat',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _quickAmount(5000),
                      _quickAmount(10000),
                      _quickAmount(20000),
                      _quickAmount(50000),
                      _quickAmount(100000),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            AnimatedOpacity(
              opacity: _cashGiven > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: _SectionCard(
                color: _isEnough
                    ? AppColors.successLight
                    : AppColors.errorLight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isEnough
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color:
                              _isEnough ? AppColors.success : AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isEnough ? 'Kembalian' : 'Kurang',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _isEnough
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatRupiah(
                        _isEnough ? _change : _totalPrice - _cashGiven,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color:
                            _isEnough ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: cartController.isLoading.value
                      ? null
                      : _isEnough
                          ? _onConfirm
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    disabledBackgroundColor: AppColors.borderLight,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: cartController.isLoading.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isEnough
                              ? 'Konfirmasi Pembayaran'
                              : 'Uang Belum Cukup',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _isEnough
                                ? AppColors.textWhite
                                : AppColors.textLight,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _quickAmount(double amount) {
    final isSelected = _cashGiven == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          _cashGiven = amount;
          _cashController.text = _formatPlain(amount.toInt());
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryRed : AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryRed : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Text(
          _formatRupiah(amount),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textWhite : AppColors.textMedium,
          ),
        ),
      ),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  static const int _maxIntDigits = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final cursorFromEnd = text.length - newValue.selection.end;

    final parts = text.split(',');
    var intDigits =
        parts[0].replaceAll('.', '').replaceAll(RegExp(r'[^0-9]'), '');
    if (intDigits.length > _maxIntDigits) {
      intDigits = intDigits.substring(0, _maxIntDigits);
    }
    final formattedInt = _addThousands(intDigits);

    var formatted = formattedInt;
    if (parts.length > 1) {
      final decDigits =
          parts.sublist(1).join().replaceAll(RegExp(r'[^0-9]'), '');
      final dec =
          decDigits.length > 2 ? decDigits.substring(0, 2) : decDigits;
      formatted += ',$dec';
    }

    var newEnd = formatted.length - cursorFromEnd;
    if (newEnd < 0) newEnd = 0;
    if (newEnd > formatted.length) newEnd = formatted.length;

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: newEnd),
    );
  }

  static String _addThousands(String digits) {
    if (digits.isEmpty) return '';
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return digits.replaceAllMapped(reg, (m) => '${m[1]}.');
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color? color;

  const _SectionCard({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? AppColors.bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}