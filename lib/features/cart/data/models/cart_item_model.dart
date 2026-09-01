import '../../../../features/home/data/models/product_model.dart';
import '../../../../features/home/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // 1. التعامل مع المنتج سواء جاء كـ Object كامل أو مجرد ID
    ProductEntity productEntity;
    
    if (json['product'] != null && json['product'] is Map<String, dynamic>) {
      productEntity = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
    } else {
      // إذا أرجع السيرفر productId فقط بدون تفاصيل المنتج
      productEntity = ProductModel(
        id: json['productId'] as int? ?? 0,
        title: 'منتج #${json['productId'] ?? 0}',
        price: 0.0,
        image: '',
        description: '',
        category: '',
        rating: const {},
      );
    }

    return CartItemModel(
      id: json['id'] as int? ?? json['productId'] as int? ?? 0,
      product: productEntity,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': ProductModel.fromEntity(product).toJson(),
      'quantity': quantity,
    };
  }
}