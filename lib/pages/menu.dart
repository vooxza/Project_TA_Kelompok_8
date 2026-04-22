import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/api_service.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuController controller = Get.find<MenuController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFB71C1C),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => Get.toNamed(AppRoutes.addMenu),
            ),
          ),
        ],
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () => controller.refreshMenuItems(),
          backgroundColor: const Color(0xFFB71C1C),
          color: Colors.white,
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: controller.menuItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No menu items available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pull to refresh',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                          itemCount: controller.menuItems.length,
                          itemBuilder: (context, index) {
                            final item = controller.menuItems[index];
                            return _buildMenuCard(
                              context,
                              item,
                              controller,
                              cartController,
                            );
                          },
                        ),
                ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    item,
    MenuController controller,
    CartController cartController,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section with Edit Button
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey[200],
                  child: item.image != null && item.image!.isNotEmpty
                      ? Image.network(
                          item.image!.startsWith('http')
                              ? item.image!
                              : '${ApiService.baseUrl.replaceAll('/api', '')}${item.image}',
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                          size: 40,
                        ),
                ),
                // Edit Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFB71C1C),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () => Get.toNamed(
                        AppRoutes.editMenu,
                        arguments: {
                          'id': item.id,
                          'name': item.name,
                          'price': item.price,
                          'image': item.image,
                        },
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description ?? '',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartController.addToCart(item);
                          Get.snackbar(
                            'Berhasil',
                            '${item.name} ditambahkan ke keranjang',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFFB71C1C),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(12),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFB71C1C),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
