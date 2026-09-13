import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:awafi_app/features/profile/domain/entities/profile_entity.dart';
import 'package:awafi_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl({required this.dataSource});

  @override
  Future<ApiResult<ProfileEntity>> getProfile() async {
    try {
      final profileModel = await dataSource.getProfile();
      return Success(profileModel.toEntity());
    } catch (e) {
      final failureObj = ApiErrorHandler.handle(e);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<ProfileEntity>> updateProfile({
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      final profileModel = await dataSource.updateProfile(
        username: username,
        email: email,
        phone: phone,
      );
      return Success(profileModel.toEntity());
    } catch (e) {
      final failureObj = ApiErrorHandler.handle(e);
      return ApiFailure(failureObj);
    }
  }
}