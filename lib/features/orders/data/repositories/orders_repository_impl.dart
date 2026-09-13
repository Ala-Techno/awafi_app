import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<OrderEntity>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    String? paymentMethod,
    String? shippingAddress,
  }) async {
    try {
      // تحويل CartItemEntity → CartItemModel للحفظ
      final cartItemModels = items
          .map((e) => CartItemModel(
                id: e.id,
                product: e.product,
                quantity: e.quantity,
              ))
          .toList();

      final orderModel = OrderModel(
        id: '',                // سيُحدَّث بـ Firestore auto-id بعد الحفظ
        userId: userId,
        date: DateTime.now().toIso8601String().split('T')[0],
        items: cartItemModels,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        shippingAddress: shippingAddress,
      );

      final saved = await remoteDataSource.placeOrder(orderModel);
      return Success(saved);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<OrderEntity>>> getOrderHistory(String userId) async {
    try {
      final orders = await remoteDataSource.getOrders(userId);
      return Success(orders);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }
}
