import '../../../../features/home/domain/entities/product_entity.dart';

/// [CartItemEntity] - كائن عنصر السلة في طبقة الـ Domain
///
/// يمُثّل منتجاً واحداً مُضافاً للسلة مع الكمية المحددة للشراء.
/// المعرّف [id] يُساوي [productId] ليتطابق مع Document ID في Firestore.
class CartItemEntity {
  final String id;        // = productId (Firestore document ID)
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
  });

  /// حساب السعر الإجمالي لهذا العنصر بناءً على الكمية
  double get itemTotalPrice => product.price * quantity;

  /// دالة نسخ الكائن لتعديل الكمية بسهولة دون إخلال بمبدأ Immutability
  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}