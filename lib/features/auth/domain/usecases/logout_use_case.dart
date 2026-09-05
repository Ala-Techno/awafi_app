import 'package:awafi_app/core/errors/api_result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_use_case.dart'; // استدعاء UseCase تسجيل الدخول
import '../../domain/usecases/logout_use_case.dart'; // استدعاء UseCase تسجيل الخروج

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get user => _user;

  Future<bool> login({
    String? email,
    String? username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final resolvedUsername = (username != null && username.isNotEmpty)
        ? username
        : (email ?? '').trim();

    // الاستدعاء يتم الآن عبر الـ UseCase وليس الـ Repository مباشرة!
    final result = await loginUseCase(
      username: resolvedUsername,
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
}