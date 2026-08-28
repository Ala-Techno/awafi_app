import 'package:awafi_app/core/errors/api_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// المدير التنفيذي لبيانات المصادقة
/// يربط طبقة الـ Data بعقد طبقة الـ Domain، ويحمي التطبيق بـ try/catch
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  // 1. حقن ساعي البريد (مصدر البيانات) عبر الـ Constructor
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 2. توجيه ساعي البريد لإجراء الاتصال والجلب
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // 3. عند النجاح: تغليف الناتج في غلاف النجاح ApiResult.success
      // (ملاحظة: userModel يُقبل كـ UserEntity تلقائياً لأنه يورث منه)
      return Success(userModel);

    } catch (error) {
      // 4. عند الفشل: الحماية وإمساك الخطأ وتغليفه في ApiResult.failure
      return Failure(
        'حدث خطأ أثناء الاتصال: ${error.toString()}',
      );
    }
  }
}