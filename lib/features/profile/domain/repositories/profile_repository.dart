import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ApiResult<ProfileEntity>> getProfile();
  Future<ApiResult<ProfileEntity>> updateProfile({
    required String username,
    required String email,
    required String phone,
  });
}
