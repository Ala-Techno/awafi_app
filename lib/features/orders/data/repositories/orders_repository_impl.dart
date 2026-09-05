import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_data_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository, CheckoutRepository {
  final OrdersLocalDataSource localDataSource;

  OrdersRepositoryImpl({required this.localDataSource});

  @override
  Future<ApiResult<OrderEntity>> placeOrder({
    required int userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    try {
      final orderModel = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: userId,
        date: DateTime.now().toIso8601String().split('T')[0],
        products: items,
        totalAmount: totalAmount,
      );

      final saved = await localDataSource.saveOrder(orderModel);
      return Success(saved);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<OrderEntity>>> getOrderHistory(int userId) async {
    try {
      final orders = await localDataSource.getOrders(userId);
      return Success(orders);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }
}
