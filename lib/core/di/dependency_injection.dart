import 'package:awafi_app/core/errors/api_error_handler.dart';
import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/core/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_factory.dart';
import '../services/shared_pref_service.dart';

// --- Auth Feature ---
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_firebase_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/domain/usecases/reset_password_use_case.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// --- Search Feature ---
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_products_usecase.dart';
import '../../features/search/presentation/providers/search_provider.dart';

// --- Home Feature ---
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_banners_usecase.dart';
import '../../features/home/domain/usecases/get_products_use_case.dart';
import '../../features/home/presentation/providers/home_provider.dart';

// --- Catalog Feature ---
import '../../features/catalog/data/datasources/catalog_remote_data_source.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/domain/usecases/get_categories_use_case.dart';
import '../../features/catalog/domain/usecases/get_products_by_category_use_case.dart';
import '../../features/catalog/presentation/providers/catalog_provider.dart';

// --- Cart Feature ---
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_use_case.dart';
import '../../features/cart/domain/usecases/clear_cart_use_case.dart';
import '../../features/cart/domain/usecases/get_cart_items_use_case.dart';
import '../../features/cart/domain/usecases/remove_from_cart_use_case.dart';
import '../../features/cart/domain/usecases/update_quantity_use_case.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

// --- Orders Feature ---
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_order_history_use_case.dart';
import '../../features/orders/domain/usecases/place_order_use_case.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';

// --- Profile Feature ---
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_use_case.dart';
import '../../features/profile/domain/usecases/update_profile_use_case.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── 1. Local Storage (SharedPreferences) ─────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(sharedPreferences),
  );

  // ── 2. Auth Local Data Source ──────────────────────────────────────────
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SharedPrefService>()),
  );

  // ── 2. Network (Dio) ─────────────────────────────────────────────────────
  final Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // ── 2.5 Firebase Instances ──────────────────────────────────────────────
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ── 3. Auth Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthFirebaseDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthProvider>(
    () => AuthProvider( 
      loginUseCase: getIt<LoginUseCase>(), 
      logoutUseCase: getIt<LogoutUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );

  // ── Search Feature ────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      localDataSource: getIt<SearchLocalDataSource>(),
      homeRepository: getIt<HomeRepository>(),
    ),
  );
  getIt.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(getIt<SearchRepository>()),
  );
  getIt.registerFactory<SearchProvider>(
    () => SearchProvider(getIt<SearchProductsUseCase>()),
  );

  // ── 4. Home Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeRemoteDataSource>(
     () => HomeFirebaseDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<HomeRepository>()),
  );
  getIt.registerFactory<HomeProvider>(
    () => HomeProvider(
      getBannersUseCase: getIt<GetBannersUseCase>(), 
      getProductsUseCase: getIt<GetProductsUseCase>(),
    ),
  );

  // ── 5. Catalog Feature ───────────────────────────────────────────────────
  getIt.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(remoteDataSource: getIt<CatalogRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CatalogRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<CatalogRepository>()),
  );
  getIt.registerFactory<CatalogProvider>(
    () => CatalogProvider(
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(), 
      getProductsByCategoryUseCase: getIt<GetProductsByCategoryUseCase>(),
    ),
  );

  // ── 6. Cart Feature ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartFirebaseDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetCartItemsUseCase>(
    () => GetCartItemsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<UpdateQuantityUseCase>(
    () => UpdateQuantityUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerFactory<CartController>(
    () => CartController(
      getCartItemsUseCase: getIt<GetCartItemsUseCase>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateQuantityUseCase: getIt<UpdateQuantityUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );

  // ── 7. Orders Feature ────────────────────────────────────────────────────
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersFirebaseDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: getIt<OrdersRemoteDataSource>()),
  );
  getIt.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerLazySingleton<GetOrderHistoryUseCase>(
    () => GetOrderHistoryUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerFactory<OrdersProvider>(
    () => OrdersProvider(
      placeOrderUseCase: getIt<PlaceOrderUseCase>(),
      getOrderHistoryUseCase: getIt<GetOrderHistoryUseCase>(),
    ),
  );

  // ── 8. Profile Feature ───────────────────────────────────────────────────
  getIt.registerLazySingleton<ProfileDataSource>(
    () => ProfileDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(), 
      auth: getIt<FirebaseAuth>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dataSource: getIt<ProfileDataSource>()),
  );
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<ProfileProvider>(
    () => ProfileProvider(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );
   // ── 9. Notification Service ────────────────────────────────────────────────────
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
}