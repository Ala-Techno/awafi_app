import 'package:awafi_app/app/awafi_app.dart'; 
import 'package:awafi_app/app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // 1. تأكيد تهيئة محرك فلاتر قبل أي خدمة
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تفعيل مكتبة الترجمة
  await EasyLocalization.ensureInitialized();

  // 3. تشغيل حقن التبعيات (GetIt & SharedPreferences & Dio)
  await setupGetIt();
 runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
     child: AwafiApp(appRouter: AppRouter()),
    ),
  );
}
