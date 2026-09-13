import 'package:awafi_app/core/errors/api_result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/reset_password_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get user => _user;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // الاستدعاء يتم الآن عبر الـ UseCase وليس الـ Repository مباشرة!
    final result = await loginUseCase(email: email, password: password);

    bool isSuccess = false;

    if (result is Success<UserEntity>) {
      _user = result.data;
      _errorMessage = null;
      isSuccess = true;
    } else if (result is ApiFailure<UserEntity>) {
      _errorMessage = result.failure.message;
      _user = null;
      isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // الاستدعاء يتم عبر الـ RegisterUseCase
    final ApiResult<UserEntity> result = await registerUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
    );

    bool isSuccess = false;

    if (result is Success<UserEntity>) {
      _user = result.data;
      _errorMessage = null;
      isSuccess = true;
    } else if (result is ApiFailure<UserEntity>) {
      _errorMessage = result.failure.message;
      _user = null;
      isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // الاستدعاء يتم عبر الـ UseCase
    await logoutUseCase();
    clearState();

    _isLoading = false;
    notifyListeners();
  }

  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _user = null;
    notifyListeners();
  }
Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await resetPasswordUseCase(email);

    result.when(
      success: (_) {
        _isLoading = false;
        _errorMessage = null;
        // هنا يمكنك إضافة منطق إضافي عند النجاح (مثل رسالة نجاح أو توجيه)
      },
      failure: (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
      },
    );

    notifyListeners();
  }}
