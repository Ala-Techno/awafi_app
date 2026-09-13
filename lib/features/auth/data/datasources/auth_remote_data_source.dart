  // import 'package:awafi_app/core/errors/exceptions.dart';
  // import 'package:awafi_app/core/network/api_constants.dart';
  // import 'package:dio/dio.dart';
  import '../models/user_model.dart';

  /// 1. Domain Contract for the remote auth operations
  abstract class AuthRemoteDataSource {
    Future<UserModel> login({
      required String email,
      required String password,
    });

    Future<UserModel> register({
      required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String phone,
    });
    Future<void> sendPasswordResetEmail(String email);
  }


  // ═══════════════════════════════════════════════════════════════════
  //   PRODUCTION SERVER — Real API Implementation
  // ═══════════════════════════════════════════════════════════════════

  // class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //   final Dio dio;

  //   AuthRemoteDataSourceImpl({required this.dio});

  //   @override
  //   Future<UserModel> login({
  //     required String email, // يستخدم كبريد إلكتروني
  //     required String password,
  //   }) async {
  //     final response = await dio.post(
  //       ApiConstants.login,
  //       data: {'email': email, 'password': password},
  //     );

  //     if (response.data is Map<String, dynamic>) {
  //       final dataMap = response.data as Map<String, dynamic>;
        
  //       if (dataMap['status'] == false || dataMap['success'] == false) {
  //         throw ServerException(
  //           message: dataMap['message']?.toString() ?? 'حدث خطأ أثناء تسجيل الدخول',
  //         );
  //       }

  //       final userData = dataMap['data'] ?? dataMap['user'] ?? dataMap;
  //       final userId = userData['id']?.toString() ?? '';
        
  //       return UserModel.fromJson(userData as Map<String, dynamic>, userId);
  //     }
      
  //     throw const ServerException(message: 'استجابة غير متوقعة من السيرفر');
  //   }

  //   Future<UserModel> register({
  //     required String firstName,
  //     required String lastName,
  //     required String email,
  //     required String password,
  //     required String phone,
  //   }) async {
  //     final response = await dio.post(
  //       ApiConstants.register,
  //       data: {
  //         'first_name': firstName,
  //         'last_name': lastName,
  //         'email': email,
  //         'password': password,
  //         'phone': phone,
  //       },
  //     );

  //     if (response.data is Map<String, dynamic>) {
  //       final dataMap = response.data as Map<String, dynamic>;
        
  //       if (dataMap['status'] == false || dataMap['success'] == false) {
  //         throw ServerException(
  //           message: dataMap['message']?.toString() ?? 'فشل إنشاء الحساب',
  //         );
  //       }

  //       final userData = dataMap['data'] ?? dataMap['user'] ?? dataMap;
  //       final userId = userData['id']?.toString() ?? '';
        
  //       return UserModel.fromJson(userData as Map<String, dynamic>, userId);
  //     }

  //     throw const ServerException(message: 'استجابة غير متوقعة من السيرفر');
  //   }
    

  //   @override
  // Future<void> sendPasswordResetEmail(String email) async {
  //   try {
  //     final response = await dio.post(
  //       ApiConstants.resetPassword,
  //       data: {'email': email},
  //     );

  //     if (response.data is Map<String, dynamic>) {
  //       final dataMap = response.data as Map<String, dynamic>;
        
  //       if (dataMap['status'] == false || dataMap['success'] == false) {
  //         throw ServerException(
  //           message: dataMap['message']?.toString() ?? 'فشل إعادة تعيين كلمة المرور',
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     throw ServerException(message: e.toString());
  //   }
  // }  
  // }
