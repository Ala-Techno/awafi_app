import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:awafi_app/features/orders/domain/entities/order_entity.dart';

abstract class CheckoutRepository {
  // دالة إتمام الطلب وإرساله
  Future<ApiResult<OrderEntity>> placeOrder({
    required int userId,
    required List<CartItemEntity> cartItems,
  });
}