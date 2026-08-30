import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<List<ProductEntity>>> getProducts();
}