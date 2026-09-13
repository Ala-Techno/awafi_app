import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:awafi_app/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  ProfileEntity? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileEntity? get profile => _profile;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getProfileUseCase.call();

    if (result is Success<ProfileEntity>) {
      _profile = result.data;
    } else if (result is ApiFailure<ProfileEntity>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await updateProfileUseCase.call(
      username: username,
      email: email,
      phone: phone,
    );

    bool isSuccess = false;

    if (result is Success<ProfileEntity>) {
      _profile = result.data;
      isSuccess = true;
    } else if (result is ApiFailure<ProfileEntity>) {
      _errorMessage = result.failure.message;
      isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}