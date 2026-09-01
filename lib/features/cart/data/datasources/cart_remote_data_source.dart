import 'package:awafi_app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/cart_item_model.dart';

/// 1. العقد (Abstract Class)
abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems(int userId);
  Future<List<CartItemModel>> addToCart(int userId, int productId, int quantity);
  Future<List<CartItemModel>> updateQuantity(int cartId, int productId, int newQuantity);
  Future<List<CartItemModel>> removeFromCart(int cartId);
  Future<List<CartItemModel>> clearCart(int cartId);
}

/// 2. التنفيذ الفعلي (Implementation)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CartItemModel>> getCartItems(int userId) async {
    try {
      final response = await dio.get('${ApiConstants.apiBaseUrl}${ApiConstants.userCart}$userId');

      final List cartsList = response.data;
      if (cartsList.isEmpty) return [];

      final List productsJson = cartsList.first['products'] ?? [];

      return productsJson.map((json) => CartItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'حدث خطأ في الاتصال بالسيرفر',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

@override
Future<List<CartItemModel>> addToCart(int userId, int productId, int quantity) async {
  try {
    final response = await dio.post(
      '${ApiConstants.apiBaseUrl}${ApiConstants.carts}',
      data: {
        'userId': userId,
        'date': DateTime.now().toIso8601String().split('T')[0],
        'products': [
          {'productId': productId, 'quantity': quantity}
        ],
      },
    );

    // حماية القراءة في حال كان response.data ليس Map
    if (response.data != null && response.data is Map<String, dynamic>) {
      final List productsJson = response.data['products'] ?? [];
      return productsJson.map((json) => CartItemModel.fromJson(json as Map<String, dynamic>)).toList();
    }

    return [];
  } on DioException catch (e) {
    throw ServerException(
      message: e.message ?? 'حدث خطأ أثناء الإضافة للسلة',
      statusCode: e.response?.statusCode,
    );
  } catch (e) {
    throw ServerException(message: 'خطأ غير متوقع: $e');
  }
}

  @override
  Future<List<CartItemModel>> updateQuantity(int cartId, int productId, int newQuantity) async {
    try {
      final response = await dio.put(
        '${ApiConstants.apiBaseUrl}${ApiConstants.carts}/$cartId',
        data: {
          'products': [
            {'productId': productId, 'quantity': newQuantity}
          ],
        },
      );

      final List productsJson = response.data['products'] ?? [];
      return productsJson.map((json) => CartItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'حدث خطأ أثناء تعديل الكمية',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> removeFromCart(int cartId) async {
    try {
      await dio.delete('${ApiConstants.apiBaseUrl}${ApiConstants.carts}/$cartId');
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'حدث خطأ أثناء الحذف من السلة',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> clearCart(int cartId) async {
    try {
      await dio.delete('${ApiConstants.apiBaseUrl}${ApiConstants.carts}/$cartId');
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'حدث خطأ أثناء إفراغ السلة',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }
}