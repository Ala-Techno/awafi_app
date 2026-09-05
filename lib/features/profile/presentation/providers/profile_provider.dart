import 'package:awafi_app/core/errors/api_result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;

  ProfileProvider({required this.profileRepository});

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

    final result = await profileRepository.getProfile();

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

    final result = await profileRepository.updateProfile(
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await profileRepository.logout();
    _profile = null;

    _isLoading = false;
    notifyListeners();
  }
}
