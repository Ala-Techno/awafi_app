import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
    required super.description,
    required super.category,
    required super.rating,
  });

  // دالة التحويل من JSON إلى Object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      rating: json['rating'] != null 
      ? Map<String, dynamic>.from(json['rating']) 
      : {},);
  }

  // دالة التحويل من Object إلى JSON (إذا احتجنا إرساله)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
      'rating': rating,
    };  
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
  return ProductModel(
    id: entity.id,
    title: entity.title,
    price: entity.price,
    description: entity.description,
    category: entity.category,
    image: entity.image,
    rating: entity.rating,
  );
}
}