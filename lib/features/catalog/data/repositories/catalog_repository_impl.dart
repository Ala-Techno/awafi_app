import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Success(categories);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<ProductEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(categoryId);
      return Success(products);
    } catch (error) {
      return ApiFailure(ApiErrorHandler.handle(error));
    }
  }
}
