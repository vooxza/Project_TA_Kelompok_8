import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../controllers/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (controller.selectedTable.value != null) {
              controller.selectedTable.value = null;
            } else {
              Get.back();
            }
          },
        ),
        title: Obx(
          () => Text(
            controller.selectedTable.value == null
                ? "RIWAYAT PESANAN"
                : controller.selectedTable.value!.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Tampilkan Total Pendapatan HANYA untuk Admin dan di menu utama history
            if (controller.isAdmin && controller.selectedTable.value == null)
              _buildRevenueCard(),

            Expanded(
              child: controller.selectedTable.value == null
                  ? _buildTableSelection()
                  : _buildOrderHistory(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Pendapatan (Semua Meja)",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            controller.formatRupiah(controller.totalRevenue.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSelection() {
    // OPSI A: Sesuaikan list di bawah ini agar persis dengan data di database (HeidiSQL)
    final List<String> tables = [
      "Meja Umum",
      "Meja 1",
      "Meja 2",
      "Meja 3",
      "Meja 4",
      "Meja 5",
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => controller.selectedTable.value = tables[index],
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tables[index].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryRed,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryRed,
                  size: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderHistory() {
    // Memfilter berdasarkan string yang dipilih (Contoh: "Meja 2" == "Meja 2")
    final filteredOrders = controller.orderList
        .where(
          (order) =>
              order['table_number'].toString().trim() ==
              controller.selectedTable.value,
        )
        .toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text("Belum ada riwayat untuk meja ini"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) => _buildOrderCard(filteredOrders[index]),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    List items = order['items'] ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ${order['order_number'] ?? '#${order['id']}'}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Selesai",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text("${item['quantity']}x ${item['product_name']}"),
                  ),
                  Text(
                    controller.formatRupiah(
                      double.parse(item['price'].toString()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                controller.formatRupiah(
                  double.parse(order['total_price'].toString()),
                ),
                style: const TextStyle(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
