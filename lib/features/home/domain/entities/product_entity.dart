/// [ProductRating] — Typed value object for product ratings in the Domain layer.
/// 
/// Using a typed class instead of Map<String, dynamic> keeps the Domain layer
/// free of raw data structures (which are a Data-layer concern).
class ProductRating {
  final double rate;
  final int count;

  const ProductRating({
    required this.rate,
    required this.count,
  });

  // ═══════════════════════════════════════════════════════════════════
  //  PRODUCTION SERVER — Extended Rating Object (Commented)
  // ═══════════════════════════════════════════════════════════════════
  // final int reviewCount;      // Total number of text reviews
  // final double? userRating;   // The authenticated user's own rating (nullable)
  // ═══════════════════════════════════════════════════════════════════
}


class ProductEntity {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final String categoryId;
  final ProductRating rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.categoryId,
    required this.rating,
  });

  // ═══════════════════════════════════════════════════════════════════
  //  PRODUCTION SERVER — Extended ProductEntity fields (Commented)
  // ═══════════════════════════════════════════════════════════════════
  // final String sku;           // Stock Keeping Unit identifier
  // final int stockQuantity;    // Available inventory
  // final String? discountCode; // Active discount/promo code
  // final double? discountedPrice; // Price after discount
  // final List<String> images;  // Multiple product images
  // final String brand;         // Product brand name
  // ═══════════════════════════════════════════════════════════════════
}