import '../../../../core/errors/api_result.dart';
import '../entities/banner_entity.dart';
import '../repositories/home_repository.dart';

class GetBannersUseCase {
  final HomeRepository repository;

  GetBannersUseCase(this.repository);

  Future<ApiResult<List<BannerEntity>>> call() async {
    return await repository.getBanners();
  }
}