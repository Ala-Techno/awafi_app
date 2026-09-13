import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<ApiResult<OrderEntity>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    String? paymentMethod,
    String? shippingAddress,
  });

  Future<ApiResult<List<OrderEntity>>> getOrderHistory(String userId);
}
