import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderHistoryUseCase {
  final OrdersRepository repository;

  const GetOrderHistoryUseCase(this.repository);

  Future<ApiResult<List<OrderEntity>>> call(String userId) {
    return repository.getOrderHistory(userId);
  }
}
