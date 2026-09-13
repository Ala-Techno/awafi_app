import 'package:awafi_app/core/errors/api_result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/search_repository.dart';

class SearchProductsUseCase {
  final SearchRepository repository;

  SearchProductsUseCase(this.repository);

  Future<ApiResult<List<ProductEntity>>> call(String query) async {
    if (query.trim().isEmpty) {
      // إرجاع قائمة فارغة داخل النجاح، أو حسب تصميم الـ ApiResult لديك
      return  Success([]); 
    }
    return await repository.searchProducts(query);
  }
}