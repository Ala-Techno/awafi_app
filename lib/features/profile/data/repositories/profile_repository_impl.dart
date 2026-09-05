import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SharedPrefService sharedPrefService;

  ProfileRepositoryImpl({required this.sharedPrefService});

  @override
  Future<ApiResult<ProfileEntity>> getProfile() async {
    final username = sharedPrefService.getString(ApiConstants.usernameKey);
    final userId = sharedPrefService.getString(ApiConstants.userIdKey);
    final email = username.isNotEmpty ? '$username@example.com' : 'user@example.com';

    final profile = ProfileEntity(
      id: userId.isNotEmpty ? userId : '1',
      username: username.isNotEmpty ? username : 'مستخدم عوافي',
      email: email,
      phone: '+966 50 000 0000',
    );

    return Success(profile);
  }

  @override
  Future<ApiResult<ProfileEntity>> updateProfile({
    required String username,
    required String email,
    required String phone,
  }) async {
    final userId = sharedPrefService.getString(ApiConstants.userIdKey);
    await sharedPrefService.setData(ApiConstants.usernameKey, username);

    final updated = ProfileEntity(
      id: userId.isNotEmpty ? userId : '1',
      username: username,
      email: email,
      phone: phone,
    );

    return Success(updated);
  }

  @override
  Future<void> logout() async {
    await sharedPrefService.removeData(ApiConstants.userTokenKey);
    await sharedPrefService.removeData(ApiConstants.userIdKey);
    await sharedPrefService.removeData(ApiConstants.usernameKey);
  }
}
