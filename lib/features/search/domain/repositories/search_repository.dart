import 'package:awafi_app/core/errors/api_result.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class SearchRepository {
  Future<ApiResult<List<ProductEntity>>> searchProducts(String query);
}