import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class PlaceOrderUseCase {
  final OrdersRepository repository;

  const PlaceOrderUseCase(this.repository);

  Future<ApiResult<OrderEntity>> call({
    required int userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String paymentMethod,
    required String shippingAddress,
  }) {
    return repository.placeOrder(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
    );
  }
}
