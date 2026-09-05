import 'dart:convert';
import 'package:awafi_app/features/cart/data/models/cart_item_model.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.products,
    required super.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    List<CartItemModel> items = [];
    if (rawProducts is List) {
      items = rawProducts
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (rawProducts is String) {
      final decoded = jsonDecode(rawProducts);
      if (decoded is List) {
        items = decoded
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    return OrderModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      products: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'products': products.map((e) => CartItemModel(
        id: e.id,
        product: e.product,
        quantity: e.quantity,
      ).toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }
}
