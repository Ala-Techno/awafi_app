import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_factory.dart';
import '../services/shared_pref_service.dart';

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
}