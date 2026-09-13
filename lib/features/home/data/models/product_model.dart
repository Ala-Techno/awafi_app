import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.categoryId,
    required super.rating,
  });

  // ═══════════════════════════════════════════════════════════════════
  //  ACTIVE CODE — FakeStore API Deserialization
  //  FakeStore rating shape: { "rate": 3.9, "count": 120 }
  // ═══════════════════════════════════════════════════════════════════

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      rating: ProductRating(
        rate: (ratingMap['rate'] as num?)?.toDouble() ?? 0.0,
        count: ratingMap['count'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'categoryId': categoryId,
      'rating': {
        'rate': rating.rate,
        'count': rating.count,
      },
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      description: entity.description,
      categoryId: entity.categoryId,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PRODUCTION SERVER — Extended fromJson (Commented)
  //  Real API may include: sku, stockQuantity, images[], brand, etc.
  // ═══════════════════════════════════════════════════════════════════
  //
  // factory ProductModel.fromJson(Map<String, dynamic> json) {
  //   final ratingMap = json['rating'] as Map<String, dynamic>? ?? {};
  //   return ProductModel(
  //     id: json['id'] as int? ?? 0,
  //     title: json['title'] as String? ?? '',
  //     price: (json['price'] as num?)?.toDouble() ?? 0.0,
  //     image: (json['images'] as List?)?.first ?? json['image'] ?? '',
  //     description: json['description'] as String? ?? '',
  //     category: json['category']?['name'] ?? json['category'] ?? '',
  //     rating: ProductRating(
  //       rate: (ratingMap['rate'] as num?)?.toDouble() ?? 0.0,
  //       count: ratingMap['count'] as int? ?? 0,
  //     ),
  //     // Extended fields:
  //     // sku: json['sku'] as String? ?? '',
  //     // stockQuantity: json['stock'] as int? ?? 0,
  //     // brand: json['brand'] as String? ?? '',
  //     // discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
  //   );
  // }
  // ═══════════════════════════════════════════════════════════════════
}