import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity {
  final String id;         // Firestore auto-generated document ID
  final String userId;     // Firebase Auth UID
  final String date;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String? shippingAddress;
  final String? paymentMethod;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.shippingAddress,
    this.paymentMethod,
  });
}