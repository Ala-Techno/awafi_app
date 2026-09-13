import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  Future<ApiResult<ProfileEntity>> call() {
    return repository.getProfile();
  }
}