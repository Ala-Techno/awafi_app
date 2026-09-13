import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserId(String uid);
  String? getCachedUserId();
  
  Future<void> cacheToken(String token);
  String? getCachedToken();
  
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPrefService _sharedPrefService;

  AuthLocalDataSourceImpl(this._sharedPrefService);

  @override
  Future<void> cacheUserId(String uid) async {
    await _sharedPrefService.setData(ApiConstants.userIdKey, uid);
  }

  @override
  String? getCachedUserId() {
    final value = _sharedPrefService.getString(ApiConstants.userIdKey);
    return value.isEmpty ? null : value;
  }

  @override
  Future<void> cacheToken(String token) async {
    await _sharedPrefService.setData(ApiConstants.userTokenKey, token);
  }

  @override
  String? getCachedToken() {
    final value = _sharedPrefService.getString(ApiConstants.userTokenKey);
    return value.isEmpty ? null : value;
  }

  @override
  Future<void> clearAuthData() async {
    await _sharedPrefService.removeData(ApiConstants.userIdKey);
    await _sharedPrefService.removeData(ApiConstants.userTokenKey);
  }
}