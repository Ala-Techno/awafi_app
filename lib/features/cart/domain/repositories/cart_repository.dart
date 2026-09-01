import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';

/// [CartRepository] - عقد مستودع السلة في طبقة الـ Domain
abstract class CartRepository {
  /// جلب جميع عناصر السلة
  Future<ApiResult<List<CartItemEntity>>> getCartItems(int userId);

  /// إضافة منتج إلى السلة باستخدام الـ ID والكمية
  Future<ApiResult<List<CartItemEntity>>> addToCart(int userId, int productId, int quantity);  

  /// تعديل كمية منتج في السلة
  Future<ApiResult<List<CartItemEntity>>> updateQuantity(int cartId, int productId, int newQuantity);

  /// حذف منتج من السلة
  Future<ApiResult<List<CartItemEntity>>> removeFromCart(int cartId);

  /// إفراغ السلة بالكامل
  Future<ApiResult<List<CartItemEntity>>> clearCart(int userId);

  /// دالة التأكد من وجود المنتج في السلة أم لا بواسطة الـ ID
  bool isProductInCart(int productId);
}