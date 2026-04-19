import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../controllers/cart_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card2.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    final List<String> mejaList = [
      "Meja 1",
      "Meja 2",
      "Meja 3",
      "Meja 4",
      "Meja 5",
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            return Column(
              children: [
                const SizedBox(height: 20),

                /// JIKA KERANJANG KOSONG
                Expanded(
                  child: cartController.cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada menu di keranjang",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: cartController.cartItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final cartItem = cartController.cartItems[index];

                            return Obx(
                              () => ProductCard2(
                                title: cartItem.product.name,
                                description: cartItem.product.description ?? '',
                                price: cartItem.product.price.toStringAsFixed(0),
                                quantity: cartItem.quantity.value,
                                onAdd: () {
                                  cartController.incrementQuantity(
                                    cartItem.product.id ?? 0,
                                  );
                                },
                                onRemove: () {
                                  cartController.decrementQuantity(
                                    cartItem.product.id ?? 0,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),

                /// bagian bawah hanya tampil kalau cart tidak kosong
                if (cartController.cartItems.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<String>(
                          isExpanded: true,
                          value: cartController.selectedTable.value,
                          hint: const Text("Pilih Nomor Meja"),
                          items: mejaList
                              .map(
                                (meja) => DropdownMenuItem<String>(
                                  value: meja,
                                  child: Text(meja),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            cartController.selectedTable.value = value;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cartController.formatRupiah(
                          cartController.totalPrice,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      if (cartController.selectedTable.value == null) {
                        Get.snackbar(
                          "Peringatan",
                          "Silakan pilih nomor meja terlebih dahulu",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                        );
                        return;
                      }

                      Get.toNamed(AppRoutes.payment);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEB6B7C),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: const Center(
                        child: Text(
                          "LANJUT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}