import 'package:awafi_app/features/home/data/datasources/home_api_service.dart';
import 'package:awafi_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:awafi_app/features/home/domain/repositories/home_repository.dart';
import 'package:awafi_app/features/home/presentation/providers/home_provider.dart';
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
    () => AuthRemoteDataSourceImpl(dio: DioFactory.getDio() ),
  );

  // ب) تسجيل المدير التنفيذي (RepositoryImpl) بالربط مع العقد (AuthRepository)
  // يطلب DataSource من GetIt تلقائياً
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>() , localDataSource: getIt<SharedPrefService>()),
  );

  // ج) تسجيل الكنترولر (AuthProvider)
  // نستخدم registerFactory حتى يُنشئ حالة جديدة عند الحاجة، ويستجلب عقد الـ Repository تلقائياً
  getIt.registerFactory<AuthProvider>(
    () => AuthProvider(authRepository: getIt<AuthRepository>()),
  );

  // ==================== Home Feature DI ====================

// 1. Data Source
  getIt.registerLazySingleton<HomeRemoteDataSource>(
  () => HomeRemoteDataSourceImpl(getIt<Dio>()),
  );

// 2. Repository
  getIt.registerLazySingleton<HomeRepository>(
  () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

// 3. Provider (نستخدم registerFactory لإنشاء نسخة جديدة مع كل فتح للشاشة)
  getIt.registerFactory<HomeProvider>(
  () => HomeProvider(homeRepository: getIt<HomeRepository>()),
  );
}