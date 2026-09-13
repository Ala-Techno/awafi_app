import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<ApiResult<ProfileEntity>> call({
    required String username,
    required String email,
    required String phone,
  }) {
    return repository.updateProfile(
      username: username,
      email: email,
      phone: phone,
    );
  }
}