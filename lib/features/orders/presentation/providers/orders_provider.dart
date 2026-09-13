import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:awafi_app/features/orders/domain/usecases/get_order_history_use_case.dart';
import 'package:awafi_app/features/orders/domain/usecases/place_order_use_case.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';

class OrdersProvider extends ChangeNotifier {
  final PlaceOrderUseCase placeOrderUseCase;
  final GetOrderHistoryUseCase getOrderHistoryUseCase;

  OrdersProvider({
    required this.placeOrderUseCase,
    required this.getOrderHistoryUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  List<OrderEntity> _orders = [];
  OrderEntity? _lastPlacedOrder;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<OrderEntity> get orders => _orders;
  OrderEntity? get lastPlacedOrder => _lastPlacedOrder;

  Future<bool> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await placeOrderUseCase.call(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
    );

    bool isSuccess = false;

    if (result is Success<OrderEntity>) {
      _lastPlacedOrder = result.data;
      _orders.insert(0, result.data);
      isSuccess = true;
    } else if (result is ApiFailure<OrderEntity>) {
      _errorMessage = result.failure.message;
      isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> fetchOrderHistory(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getOrderHistoryUseCase.call(userId);

    if (result is Success<List<OrderEntity>>) {
      _orders = result.data;
    } else if (result is ApiFailure<List<OrderEntity>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }
}
