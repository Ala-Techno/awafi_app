import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:awafi_app/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';


class ProductGridWidget extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        // هنا الاستخدام الصحيح: استدعاء الكارد المستقل وإرسال المنتج له
        return ProductCard(product: product); 
      },
    );
  }
}