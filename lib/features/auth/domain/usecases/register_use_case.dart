import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<ApiResult<UserEntity>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
