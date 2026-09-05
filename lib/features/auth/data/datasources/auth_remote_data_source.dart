import 'package:awafi_app/core/errors/exceptions.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// 1. Domain Contract for the remote auth operations
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  ACTIVE CODE — FakeStore API Implementation
//  Endpoint: POST https://fakestoreapi.com/auth/login
//  Body:     { "username": "...", "password": "..." }
//  Response: { "token": "eyJ..." }
// ═══════════════════════════════════════════════════════════════════

/// 2. FakeStore Implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {
        'username': username, // FakeStore requires 'username', NOT 'email'
        'password': password,
      },
    );

    // FakeStore returns: { "token": "eyJhbGci..." }
    // We validate the response has a token field before proceeding.
    if (response.data is Map<String, dynamic>) {
      final dataMap = response.data as Map<String, dynamic>;

      // Explicit failure signal from server (e.g., status: false)
      if (dataMap.containsKey('status') && dataMap['status'] == false) {
        throw ServerException(
          message: dataMap['message']?.toString() ?? dataMap['error']?.toString(),
        );
      }

      // FakeStore wraps token in 'data' sometimes; handle both shapes.
      if (dataMap.containsKey('data') && dataMap['data'] != null) {
        return UserModel.fromFakeStoreJson(dataMap['data'], username: username);
      }

      // Standard FakeStore shape: { "token": "..." }
      return UserModel.fromFakeStoreJson(dataMap, username: username);
    }

    throw const ServerException(message: 'استجابة غير متوقعة من السيرفر');
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PRODUCTION SERVER — Real API Implementation (Commented)
//  Endpoint: POST https://api.awafi-store.com/v1/auth/login
//  Body:     { "email": "...", "password": "..." }
//  Response: {
//    "token": "eyJ...",
//    "refresh_token": "eyJ...",
//    "user": { "id": "uuid", "name": "...", "email": "...", "roles": [...] }
//  }
// ═══════════════════════════════════════════════════════════════════
//
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final Dio dio;
//   AuthRemoteDataSourceImpl({required this.dio});
//
//   @override
//   Future<UserModel> login({
//     required String username, // 'username' used as email for prod
//     required String password,
//   }) async {
//     final response = await dio.post(
//       ApiConstants.login,
//       data: {'email': username, 'password': password},
//     );
//
//     if (response.data is Map<String, dynamic>) {
//       final dataMap = response.data as Map<String, dynamic>;
//       if (dataMap['status'] == false || dataMap['success'] == false) {
//         throw ServerException(message: dataMap['message']?.toString());
//       }
//       // Real API wraps user inside 'data' or 'user' key
//       final userData = dataMap['data'] ?? dataMap['user'] ?? dataMap;
//       return UserModel.fromJson(userData as Map<String, dynamic>);
//     }
//     throw const ServerException(message: 'استجابة غير متوقعة من السيرفر');
//   }
//
//   Future<UserModel> register({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     final response = await dio.post(
//       ApiConstants.register,
//       data: {'name': name, 'email': email, 'password': password, 'phone': phone},
//     );
//     final dataMap = response.data as Map<String, dynamic>;
//     return UserModel.fromJson(dataMap['data']);
//   }
// }