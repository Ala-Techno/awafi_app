import 'package:awafi_app/core/errors/exceptions.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/features/home/data/models/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

// 1. العقد
abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<BannerModel>> getBanners();
   List<ProductModel> get cachedProducts;

}

class HomeFirebaseDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore _firestore;
  List<ProductModel> _cachedProducts = [];

  List<ProductModel> get cachedProducts => _cachedProducts;

  HomeFirebaseDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  /// دالة مركزية للتعامل مع أخطاء فايربيس الخاصة بقاعدة البيانات
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'حدث خطأ في قاعدة البيانات');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    return _guard(() async {
      final querySnapshot = await _firestore.collection('products').get();

    _cachedProducts = querySnapshot.docs.map((doc) {final data = doc.data();return ProductModel.fromJson(data);
      }).toList();

      return _cachedProducts;
    });
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    return _guard(() async {
      final querySnapshot = await _firestore
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return querySnapshot.docs.map((doc) {
        return BannerModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
}
 // 2. التنفيذ (نقّي وبدون try/catch)
// class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
//   final Dio _dio;

//   HomeRemoteDataSourceImpl(this._dio);

//   @override
//   Future<List<ProductModel>> getProducts() async {
   
//       final response = await _dio.get(ApiConstants.products);
      
//       final List<dynamic> data = response.data;
//       return data.map((json) => ProductModel.fromJson(json)).toList();
    

  
//   }
// }