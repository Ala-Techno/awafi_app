import 'package:dio/dio.dart';
import '../models/user_model.dart';

// 1. العقد المجرد
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

// 2. التنفيذ الفعلي
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // الاتصال بالشبكة
    final response = await dio.post(
      'https://example.com/api/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    // استدعاء أداة التحويل من ملف الـ Model
    return UserModel.fromJson(response.data);
  }
}