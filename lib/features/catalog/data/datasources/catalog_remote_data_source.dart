

import 'package:awafi_app/features/catalog/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/data/models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final FirebaseFirestore _firestore;

CatalogRemoteDataSourceImpl({required FirebaseFirestore firestore}) : _firestore = firestore;
@override
Future<List<CategoryModel>> getCategories() async {
  final querySnapshot = await _firestore.collection('categories').get();
  
  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    return CategoryModel.fromJson(data, doc.id); // 👈 نمرر doc.id كصمام أمان
  }).toList();
}
 
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    // جلب المنتجات مطابقة للـ categoryId الذي خزناه في السيرفر
    final querySnapshot = await _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson(data);
    }).toList();
  }
}









// import 'package:awafi_app/core/network/api_constants.dart';
// import 'package:dio/dio.dart';
// import '../../../home/data/models/product_model.dart';

// abstract class CatalogRemoteDataSource {
//   Future<List<String>> getCategories();
//   Future<List<ProductModel>> getProductsByCategory(String categoryId);
// }

// class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
//   final Dio dio;

//   CatalogRemoteDataSourceImpl({required this.dio});

//   @override
//   Future<List<String>> getCategories() async {
//     final response = await dio.get(ApiConstants.categories);
//     final List<dynamic> data = response.data;
//     return data.map((e) => e.toString()).toList();
//   }

//   @override
//   Future<List<ProductModel>> getProductsByCategory(String category) async {
//     final response = await dio.get('${ApiConstants.productsByCategory}$category');
//     final List<dynamic> data = response.data;
//     return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
//   }
// }
