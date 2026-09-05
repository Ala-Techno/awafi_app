import 'package:awafi_app/core/errors/api_result.dart';
import '../entities/user_entity.dart';

/// [AuthRepository] — Domain contract for all authentication operations.
/// Pure Dart. No dependencies on Data or Presentation layers.
abstract class AuthRepository {
  /// Authenticates the user with the backend.
  /// Returns [UserEntity] on success or a [Failure] on error.
  Future<ApiResult<UserEntity>> login({
    required String username,
    required String password,
  });

  /// Clears the user session from local storage.
  /// Called by the Logout flow.
  Future<void> logout();

  // ═══════════════════════════════════════════════════════════════════
  //  PRODUCTION SERVER — Extended Repository Contract (Commented)
  // ═══════════════════════════════════════════════════════════════════
  //
  // /// Registers a new user account.
  // Future<ApiResult<UserEntity>> register({
  //   required String name,
  //   required String email,
  //   required String password,
  //   required String phone,
  // });
  //
  // /// Refreshes the access token using the stored refresh token.
  // Future<ApiResult<UserEntity>> refreshToken();
  //
  // /// Sends a password reset email.
  // Future<ApiResult<void>> forgotPassword({required String email});
  //
  // /// Checks if the current session token is still valid.
  // Future<bool> isSessionValid();
  // ═══════════════════════════════════════════════════════════════════
}