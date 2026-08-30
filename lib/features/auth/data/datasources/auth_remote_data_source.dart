import 'package:awafi_app/core/errors/exceptions.dart';
import 'package:awafi_app/core/network/api_constants.dart';
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
  final response = await dio.post(
   ApiConstants.login,
    data: {
      'email': email,
      'password': password,
    },
  );

  // 1. فحص هل الـ JSON يحوي مؤشر فشل صريح من الباك إند (status: false)
  if (response.data is Map<String, dynamic>) {
    final dataMap = response.data as Map<String, dynamic>;

    // إذا أرجع السيرفر صراحة أن العملية فشلت
    if (dataMap.containsKey('status') && dataMap['status'] == false) {
      // نأخذ النص من السيرفر، وإن لم يوجد نمرر null لتتولى الـ ?? في الـ Handler وضع النص الاحتياطي
      throw ServerException(
        message: dataMap['message'] ?? dataMap['error'],
      );
    }

    // 2. إذا كانت العملية ناجحة، نحول البيانات
    if (dataMap.containsKey('data') && dataMap['data'] != null) {
      return UserModel.fromJson(dataMap['data']);
    }
  }

  // 3. إذا جاء الـ JSON بشكل مباشر ومباشر بدون wrapper (طبيعي)
  return UserModel.fromJson(response.data);
}
}