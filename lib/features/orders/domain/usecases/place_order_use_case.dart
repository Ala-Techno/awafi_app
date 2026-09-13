import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class PlaceOrderUseCase {
  final OrdersRepository repository;

  const PlaceOrderUseCase(this.repository);

  Future<ApiResult<OrderEntity>> call({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    String? paymentMethod,
    String? shippingAddress,
  }) {
    return repository.placeOrder(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod ?? 'cash',
      shippingAddress: shippingAddress ?? 'no address',
    );
  }
}
