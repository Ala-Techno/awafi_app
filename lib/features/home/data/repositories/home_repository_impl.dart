import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<ProductEntity>>> getProducts() async {
    try {
      // 1. جلب البيانات من الـ Remote Data Source
      final productsList = await _remoteDataSource.getProducts();

      // 2. إرجاع النتيجة بنجاح مغلفة داخل ApiResult.success
      // (ملاحظة: ProductModel يرث من ProductEntity لذا يُقبل مباشرة)
      return Success(productsList);
    } catch (error) {
    // 3. ترجمة الخطأ إلى Failure ملموس
      final Failure failureObj = ApiErrorHandler.handle(error);

      // 4. إرجاع الفشل مغلفاً داخل ApiFailure
      return ApiFailure(failureObj);
    }
  }
}