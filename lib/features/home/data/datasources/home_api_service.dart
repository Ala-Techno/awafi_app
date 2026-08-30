import 'package:awafi_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

// 1. العقد
abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

// 2. التنفيذ (نقّي وبدون try/catch)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiConstants.products);
      
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      // طباعة الخطأ الفعلي مع مكان حدوثه في الـ Debug Console
      print('=================== API ERROR DETECTED ===================');
      print('❌ Error details: $e');
      print('📍 Stack trace: $stackTrace');
      print('==========================================================');
      rethrow; // نرجع نرفع الخطأ للـ Repository مثل ما هو بدون تغيير
    }
  }
}