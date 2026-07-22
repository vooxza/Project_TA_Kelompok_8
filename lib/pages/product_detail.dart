import 'package:flutter/material.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/product_detail_mobile.dart';
import 'wide/product_detail_wide.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ProductDetailPageMobile(),
      wide: ProductDetailPageWide(),
    );
  }
}
