import 'package:awafi_app/core/errors/api_result.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class CatalogRepository {
  Future<ApiResult<List<String>>> getCategories();
  Future<ApiResult<List<ProductEntity>>> getProductsByCategory(String category);
}
