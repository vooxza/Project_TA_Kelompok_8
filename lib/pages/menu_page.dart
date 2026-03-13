import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "menu",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// GRID MENU
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
          children: const [
            MenuCard(title: "Soto Ayam"),
            MenuCard(title: "Minuman"),
            MenuCard(title: "Gorengan"),
            MenuCard(title: "Kerupuk"),
            MenuCard(title: "Soto Ayam"),
            MenuCard(title: "Minuman"),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 1,),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;

  const MenuCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Stack(
        children: [
          
          /// ISI CARD
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              /// ICON / GAMBAR MENU
              const Center(
                child: Icon(
                  Icons.fastfood,
                  size: 70,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              /// NAMA MENU
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              /// JUMLAH VARIAN
              const Text(
                "5 Varian",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          /// TOMBOL KERANJANG
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 55,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFB71C1C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}