import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity {
  final int id;
  final int userId;
  final String date;
  final List<CartItemEntity> products;   // المنتجات التي تم شراؤها
  final double totalAmount;            // المبلغ الإجمالي

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
    required this.totalAmount,
  });
}