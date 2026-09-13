import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import '../repositories/catalog_repository.dart';

class GetCategoriesUseCase {
  final CatalogRepository repository;

  const GetCategoriesUseCase(this.repository);

  Future<ApiResult<List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
