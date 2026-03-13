import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/menu_page.dart';
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> mejaList = [
      "Meja 1",
      "Meja 2",
      "Meja 3",
      "Meja 4",
      "Meja 5",
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// HEADER
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.off(() => const MenuPage());
                    },
                  ),
                  SizedBox(width: 15),
                  Text(
                    "KERANJANG",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// LIST ITEM
              Expanded(
                child: ListView(
                  children: const [
                    CartItem(),
                    SizedBox(height: 15),
                    CartItem(),
                    SizedBox(height: 15),
                    CartItem(),
                  ],
                ),
              ),

              /// DROPDOWN MEJA
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black12),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Pilih Nomor Meja"),
                    items: mejaList
                        .map(
                          (meja) =>
                              DropdownMenuItem(value: meja, child: Text(meja)),
                        )
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TOTAL HARGA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Harga",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "45.000",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// BUTTON LANJUT
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "LANJUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// GAMBAR
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/images/soto.jpg",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, color: Colors.white, size: 60),
            ),
          ),

          const SizedBox(width: 12),

          /// DESKRIPSI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Soto Ayam Spesial",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Soto ayam spesial khas dari Mbok Kerso",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                SizedBox(height: 8),

                Text(
                  "Rp 15.000",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// COUNTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.remove, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text("1", style: TextStyle(color: Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.add, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
