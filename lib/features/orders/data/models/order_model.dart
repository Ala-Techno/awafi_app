import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../../cart/data/models/cart_item_model.dart';

/// [OrderModel] — نموذج البيانات للطلب في طبقة Data
///
/// هيكل Firestore المستهدف في orders/{orderId}:
/// {
///   "userId":          "firebase_uid",
///   "date":            "2026-09-09",
///   "totalAmount":     149.99,
///   "paymentMethod":   "بطاقة ائتمان / مدى",
///   "shippingAddress": "شارع الملك فهد، الرياض",
///   "items": [
///     { "productId": "abc", "title": "...", "price": 49.99, "imageUrl": "...", "quantity": 2 }
///   ],
///   "createdAt": Timestamp
/// }
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.items,
    required super.totalAmount,
    super.shippingAddress,
    super.paymentMethod,
  });

  // ─── Firestore Read ───────────────────────────────────────────────────────
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawItems = data['items'] as List<dynamic>? ?? [];

    final items = rawItems
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      date: data['date'] as String? ?? '',
      items: items,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: data['shippingAddress'] as String?,
      paymentMethod: data['paymentMethod'] as String?,
    );
  }

  // ─── Firestore Write ──────────────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': date,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod ?? 'cash',
      'shippingAddress': shippingAddress ?? 'no address',
      'items': items.map((e) => CartItemModel(
            id: e.id,
            product: e.product,
            quantity: e.quantity,
          ).toJson()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // ─── Legacy JSON (SharedPreferences fallback) ─────────────────────────────
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      items: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: json['shippingAddress'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toFirestore();
}
