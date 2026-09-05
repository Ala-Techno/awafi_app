import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  const GetProductsUseCase(this.repository);

  Future<ApiResult<List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}
