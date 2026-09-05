import 'package:awafi_app/core/errors/api_result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

class GetProductsByCategoryUseCase {
  final CatalogRepository repository;

  const GetProductsByCategoryUseCase(this.repository);

  Future<ApiResult<List<ProductEntity>>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}
