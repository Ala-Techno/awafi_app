import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class CatalogRepository {
  Future<ApiResult<List<CategoryEntity>>> getCategories();
  Future<ApiResult<List<ProductEntity>>> getProductsByCategory(String categoryId);
}
