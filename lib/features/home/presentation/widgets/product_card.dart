import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../../app/routing/routes.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetailsScreen,
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم الصورة (موسطة ومتناسقة تماماً)
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: Colors.white54,
                  padding: const EdgeInsets.all(8.0), // مسافة محيطة لضمان عدم التصاق الصورة بالأطراف
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.contain, // يضمن إظهار الصورة كاملة وتوسيطها بشكل جميل
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image, size: 36, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // 2. تفاصيل المنتج (العنوان، الوصف، التقييم، والسعر)
            Expanded(
              flex: 5,
              child: 
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان المنتج
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // وصف مختصر (إن وجد في الـ Entity، وإذا لم يوجد يمكنك استبداله أو إزالته)
                        Text(
                          product.description ?? '', 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // التقييم (Rating) والسعر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ميزة التقييم (نجمة + الرقم)
                       Row(
                        children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${product.rating.rate}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        const SizedBox(width: 4),
                        Text('(${product.rating.count})', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                        ],
                      ),
                        const SizedBox(height: 4),
                        // السعر
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
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
      ),
    );
  }
}