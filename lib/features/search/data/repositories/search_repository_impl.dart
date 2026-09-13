import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/search/data/datasources/search_remote_data_source.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;
  final HomeRepository homeRepository;
  SearchRepositoryImpl({
    required this.localDataSource,
    required this.homeRepository,
  });

  @override
  Future<ApiResult<List<ProductEntity>>> searchProducts(String query) async {
    try {
      final allProducts = await homeRepository.getCachedProducts();
final results = localDataSource.searchProducts(allProducts, query);      return Success(results);
    } catch (e) {
      final failure = ApiErrorHandler.handle(e);
      return ApiFailure(failure);
    }
  }
}
