import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_factory.dart';
import '../services/shared_pref_service.dart';

// --- استيراد ملفات الـ Auth الخاصة بمشروعنا ---
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── 1. Local Storage (SharedPreferences) ─────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(sharedPreferences),
  );

  // ── 2. Network (Dio) ─────────────────────────────────────────────────────
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // ── 3. Auth Feature (تسجيل طبقات المصادقة) ────────────────────────────────

  // أ) تسجيل ساعي البريد (DataSource)
  // يطلب Dio من GetIt تلقائياً عبر getIt<Dio>()
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // ب) تسجيل المدير التنفيذي (RepositoryImpl) بالربط مع العقد (AuthRepository)
  // يطلب DataSource من GetIt تلقائياً
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // ج) تسجيل الكنترولر (AuthProvider)
  // نستخدم registerFactory حتى يُنشئ حالة جديدة عند الحاجة، ويستجلب عقد الـ Repository تلقائياً
  getIt.registerFactory<AuthProvider>(
    () => AuthProvider(authRepository: getIt<AuthRepository>()),
  );
}