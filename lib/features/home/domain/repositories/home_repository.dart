import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/home/domain/entities/banner_entity.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<List<ProductEntity>>> getProducts();
  Future<ApiResult<List<BannerEntity>>> getBanners();
 Future<List<ProductEntity>> getCachedProducts();
}