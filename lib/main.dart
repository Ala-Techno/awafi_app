import 'package:awafi_app/app/awafi_app.dart'; 
import 'package:awafi_app/app/routing/app_router.dart';
import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // 1. تأكيد تهيئة محرك فلاتر قبل أي خدمة
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تفعيل مكتبة الترجمة
  await EasyLocalization.ensureInitialized();

// 3. تشغيل حقن التبعيات (GetIt & SharedPreferences & Dio) 🟢 (مكانه الصحيح هنا أولاً)
  await setupGetIt();

  // 4. قراءة التوكن المحفوظ من الذاكرة المحلية (بعد جاهزية setupGetIt)
  final sharedPref = getIt<SharedPrefService>();
  final String? token = sharedPref.getString(ApiConstants.userTokenKey);

  // 5. تحديد المسار الأولي: إذا كان التوكن موجوداً وغير فارغ يذهب للرئيسية مباشرة
  final String initialRoute = (token != null && token.isNotEmpty)
      ? Routes.homeScreen
      : Routes.loginScreen; 
 runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: AwafiApp(appRouter: AppRouter(), initialRoute: initialRoute),
    ),
  );
}
