import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/home/data/models/product_model.dart';
import '../../../../features/home/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

/// [CartItemModel] — طبقة البيانات لعنصر السلة
///
/// هيكل Firestore المستهدف في carts/{userId}/items/{productId}:
/// {
///   "productId": "abc123",
///   "quantity": 2,
///   "addedAt": Timestamp
/// }
///
/// يتم جلب تفاصيل المنتج (title, price, imageUrl) من products/{productId}
/// ودمجها مع هذا المودل لإكمال بنية [CartItemEntity].
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  // ─── Firestore Read ───────────────────────────────────────────────────────
  /// يبني نموذجاً من document الـ Firestore (يحتاج كائن المنتج منفصلاً)
  factory CartItemModel.fromFirestore({
    required DocumentSnapshot doc,
    required ProductEntity product,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      id: doc.id,               // productId = Document ID
      product: product,
      quantity: data['quantity'] as int? ?? 1,
    );
  }

  // ─── Firestore Write ──────────────────────────────────────────────────────
  /// يحوّل العنصر إلى Map لحفظه في Firestore (productId + quantity فقط)
  Map<String, dynamic> toFirestore() {
    return {
      'productId': id,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }

  // ─── JSON (للـ Orders Snapshot) ───────────────────────────────────────────
  /// يبني نموذجاً من JSON (يُستخدم عند قراءة Snapshot المنتج داخل الطلب)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    ProductEntity productEntity;

    if (json['product'] != null && json['product'] is Map<String, dynamic>) {
      productEntity = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
    } else {
      productEntity = ProductModel(
        id: json['productId'] as String? ?? '',
        title: json['title'] as String? ?? 'منتج',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: json['imageUrl'] as String? ?? '',
        description: '',
        categoryId: '',
        rating: const ProductRating(rate: 0.0, count: 0),
      );
    }

    return CartItemModel(
      id: json['productId'] as String? ?? json['id'] as String? ?? '',
      product: productEntity,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  /// يحوّل العنصر إلى Map لحفظه كـ snapshot داخل الطلب
  Map<String, dynamic> toJson() {
    return {
      'productId': id,
      'title': product.title,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'quantity': quantity,
    };
  }
}