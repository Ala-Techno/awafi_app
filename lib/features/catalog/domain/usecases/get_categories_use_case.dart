import 'package:awafi_app/core/errors/api_result.dart';
import '../repositories/catalog_repository.dart';

class GetCategoriesUseCase {
  final CatalogRepository repository;

  const GetCategoriesUseCase(this.repository);

  Future<ApiResult<List<String>>> call() {
    return repository.getCategories();
  }
}
