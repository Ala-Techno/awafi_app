import 'dart:convert';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import '../models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<OrderModel> saveOrder(OrderModel order);
  Future<List<OrderModel>> getOrders(int userId);
  
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final SharedPrefService sharedPrefService;

  OrdersLocalDataSourceImpl({required this.sharedPrefService});

  @override
  Future<OrderModel> saveOrder(OrderModel order) async {
    final existingJson = sharedPrefService.getString(ApiConstants.orderHistoryKey);
    List<dynamic> list = [];
    if (existingJson.isNotEmpty) {
      try {
        list = jsonDecode(existingJson) as List<dynamic>;
      } catch (_) {
        list = [];
      }
    }

    list.add(order.toJson());
    await sharedPrefService.setData(ApiConstants.orderHistoryKey, jsonEncode(list));
    return order;

  }

  @override
  Future<List<OrderModel>> getOrders(int userId) async {
    final existingJson = sharedPrefService.getString(ApiConstants.orderHistoryKey);
    if (existingJson.isEmpty) return [];

    try {
      final List<dynamic> list = jsonDecode(existingJson) as List<dynamic>;
      return list
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .where((order) => order.userId == userId || order.userId == 0 || userId == 0)
          .toList()
          .reversed
          .toList();
    } catch (_) {
      return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PRODUCTION SERVER — Real Orders Remote DataSource (Commented)
// ═══════════════════════════════════════════════════════════════════
// class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
//   final Dio dio;
//   OrdersRemoteDataSourceImpl({required this.dio});
//
//   Future<OrderModel> placeOrder(Map<String, dynamic> orderPayload) async {
//     final response = await dio.post(ApiConstants.placeOrder, data: orderPayload);
//     return OrderModel.fromJson(response.data['data']);
//   }
//
//   Future<List<OrderModel>> getOrders(int userId) async {
//     final response = await dio.get('${ApiConstants.userOrders}$userId');
//     final list = response.data['data'] as List;
//     return list.map((json) => OrderModel.fromJson(json)).toList();
//   }
// }
