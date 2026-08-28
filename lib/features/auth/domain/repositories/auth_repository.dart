import '../../../../core/errors/api_result.dart';
import '../entities/user_entity.dart';


abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login({
    required String email,
    required String password,
  });
}