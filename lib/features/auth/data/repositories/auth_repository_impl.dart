import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/errors/failures.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// المدير التنفيذي لبيانات المصادقة
/// يربط طبقة الـ Data بعقد طبقة الـ Domain، ويحمي التطبيق بـ try/catch
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPrefService localDataSource;

  // 1. حقن ساعي البريد (مصدر البيانات) ومصدر التخزين المحلي
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ApiResult<UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      // 2. توجيه ساعي البريد لإجراء الاتصال والجلب
      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      // 3. حفظ التوكن وبيانات المستخدم محلياً في ذاكرة الجهاز إذا كان موجوداً
      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await localDataSource.setData(ApiConstants.userTokenKey, userModel.token!);
        await localDataSource.setData(ApiConstants.userIdKey, userModel.id);
        await localDataSource.setData(ApiConstants.usernameKey, userModel.username);
      }

      // 4. عند النجاح: تغليف الناتج في غلاف النجاح Success
      return Success(userModel);
    } catch (error) {
      // ترجمة الخطأ إلى Failure
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.removeData(ApiConstants.userTokenKey);
    await localDataSource.removeData(ApiConstants.userIdKey);
    await localDataSource.removeData(ApiConstants.usernameKey);
  }
}