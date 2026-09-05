import 'package:awafi_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import '../../../home/data/models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final Dio dio;

  CatalogRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<String>> getCategories() async {
    final response = await dio.get(ApiConstants.categories);
    final List<dynamic> data = response.data;
    return data.map((e) => e.toString()).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await dio.get('${ApiConstants.productsByCategory}$category');
    final List<dynamic> data = response.data;
    return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
