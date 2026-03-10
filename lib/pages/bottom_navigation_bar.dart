import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text("BERANDA", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("MENU", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("KERANJANG", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
