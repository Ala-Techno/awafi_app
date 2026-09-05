import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_factory.dart';
import '../services/shared_pref_service.dart';

// --- Auth Feature ---
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// --- Home Feature ---
import '../../features/home/data/datasources/home_api_service.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/providers/home_provider.dart';

// --- Catalog Feature ---
import '../../features/catalog/data/datasources/catalog_remote_data_source.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/presentation/providers/catalog_provider.dart';

// --- Cart Feature ---
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

// --- Orders Feature ---
import '../../features/orders/data/datasources/orders_local_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/checkout_repository.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';

// --- Profile Feature ---
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── 1. Local Storage (SharedPreferences) ─────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(sharedPreferences),
  );

  // ── 2. Network (Dio) ─────────────────────────────────────────────────────
  final Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // ── 3. Auth Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<SharedPrefService>(),
    ),
  );
  getIt.registerFactory<AuthProvider>(
    () => AuthProvider(authRepository: getIt<AuthRepository>()),
  );

  // ── 4. Home Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerFactory<HomeProvider>(
    () => HomeProvider(homeRepository: getIt<HomeRepository>()),
  );

  // ── 5. Catalog Feature ───────────────────────────────────────────────────
  getIt.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(remoteDataSource: getIt<CatalogRemoteDataSource>()),
  );
  getIt.registerFactory<CatalogProvider>(
    () => CatalogProvider(catalogRepository: getIt<CatalogRepository>()),
  );

  // ── 6. Cart Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
  );
  getIt.registerFactory<CartController>(
    () => CartController(cartRepository: getIt<CartRepository>()),
  );

  // ── 7. Orders Feature ────────────────────────────────────────────────────
  getIt.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(sharedPrefService: getIt<SharedPrefService>()),
  );
  getIt.registerLazySingleton<OrdersRepositoryImpl>(
    () => OrdersRepositoryImpl(localDataSource: getIt<OrdersLocalDataSource>()),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => getIt<OrdersRepositoryImpl>(),
  );
  getIt.registerLazySingleton<CheckoutRepository>(
    () => getIt<OrdersRepositoryImpl>(),
  );
  getIt.registerFactory<OrdersProvider>(
    () => OrdersProvider(ordersRepository: getIt<OrdersRepository>()),
  );

  // ── 8. Profile Feature ───────────────────────────────────────────────────
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sharedPrefService: getIt<SharedPrefService>()),
  );
  getIt.registerFactory<ProfileProvider>(
    () => ProfileProvider(profileRepository: getIt<ProfileRepository>()),
  );
}