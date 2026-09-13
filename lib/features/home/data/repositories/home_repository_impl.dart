import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/errors/failures.dart';
import 'package:awafi_app/features/home/domain/entities/banner_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  List<ProductEntity> _allProductsCache = [];
  

  HomeRepositoryImpl(this._remoteDataSource);

@override
  Future<List<ProductEntity>> getCachedProducts() async {
    if (_allProductsCache.isEmpty) {
      // إذا الكاش فارغ، نجلب المنتجات من السيرفر ونحدث الكاش
      final productModels = await _remoteDataSource.getProducts(); 
      _allProductsCache = List<ProductEntity>.from(productModels);
    }
    // إرجاع الكاش سواء كان موجود مسبقاً أو تم جلبه للتو
    return _allProductsCache;
  }
  @override
  Future<ApiResult<List<ProductEntity>>> getProducts() async {
    try {
      final productModels = await _remoteDataSource.getProducts();
      // تحديث الكاش
      _allProductsCache = List<ProductEntity>.from(productModels);      
      return Success(_allProductsCache);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }
  @override
  Future<ApiResult<List<BannerEntity>>> getBanners() async {
    try {
      final bannerModels = await _remoteDataSource.getBanners();
      // بما أن BannerModel يرث من BannerEntity، يمكن إرجاعه مباشرة كقائمة Entities
      return Success(bannerModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }


  // @override
  // Future<ApiResult<List<ProductEntity>>> getProducts() async {
  //   try {
  //     // 1. جلب البيانات من الـ Remote Data Source
  //     final productsList = await _remoteDataSource.getProducts();

  //     // 2. إرجاع النتيجة بنجاح مغلفة داخل ApiResult.success
  //     // (ملاحظة: ProductModel يرث من ProductEntity لذا يُقبل مباشرة)
  //     return Success(productsList);
  //   } catch (error) {
  //   // 3. ترجمة الخطأ إلى Failure ملموس
  //     final Failure failureObj = ApiErrorHandler.handle(error);

  //     // 4. إرجاع الفشل مغلفاً داخل ApiFailure
  //     return ApiFailure(failureObj);
  //   }
  // }
}