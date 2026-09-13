import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/errors/failures.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import 'package:awafi_app/core/utils/unit.dart';
import 'package:awafi_app/features/auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// المدير التنفيذي لبيانات المصادقة
/// يربط طبقة الـ Data بعقد طبقة الـ Domain، ويحمي التطبيق بـ try/catch
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ApiResult<UserEntity>> login({
    required String email, // يُرسل كبريد إلكتروني
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

// تخزين بيانات المستخدم الأساسية محلياً (مع الاحتفاظ بـ id والبريد للاستخدام السريع)
    await localDataSource.cacheUserId(userModel.id);
    
    

      return Success(userModel);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
      );

     await localDataSource.cacheUserId(userModel.id);
      

      return Success(userModel);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }
  
  

  @override
  Future<void> logout() async {
    await localDataSource.clearAuthData();
    
  }

  @override
  Future<ApiResult<Unit>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return Success(unit);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }
}