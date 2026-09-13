import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';

/// [CartRepository] - عقد مستودع السلة في طبقة الـ Domain
abstract class CartRepository {
  /// جلب جميع عناصر السلة للمستخدم من Firestore
  Future<ApiResult<List<CartItemEntity>>> getCartItems(String userId);

  /// إضافة منتج إلى السلة أو تحديث كميته إن كان موجوداً
  Future<ApiResult<List<CartItemEntity>>> addToCart(
      String userId, String productId, int quantity);

  /// تعديل كمية منتج في السلة
  Future<ApiResult<List<CartItemEntity>>> updateQuantity(
      String userId, String productId, int newQuantity);

  /// حذف منتج من السلة
  Future<ApiResult<List<CartItemEntity>>> removeFromCart(
      String userId, String productId);

  /// إفراغ السلة بالكامل
  Future<ApiResult<List<CartItemEntity>>> clearCart(String userId);

  /// دالة التأكد من وجود المنتج في السلة أم لا بواسطة الـ ID
  bool isProductInCart(String productId);
}