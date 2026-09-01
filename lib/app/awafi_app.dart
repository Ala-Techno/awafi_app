import 'package:awafi_app/core/di/dependency_injection.dart';
import 'package:awafi_app/core/theme/app_theme.dart';
import 'package:awafi_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:awafi_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart'; // 👈 إضافة إمبورت الباكيج
import 'routing/app_router.dart';

class AwafiApp extends StatelessWidget {
  final AppRouter appRouter;
  final String initialRoute;

  const AwafiApp({
    super.key, 
    required this.appRouter, 
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    // 👈 تغليف MaterialApp بـ MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<CartController>(), // نسجّل الكنترولر مرة واحدة للتطبيق كامل
        ),
        // 2. حالة تسجيل الدخول (إذا كانت تتشاركها عدة شاشات)
      ChangeNotifierProvider(
        create: (_) => getIt<AuthProvider>(),
      ),
      ],
      child: MaterialApp(
        title: 'Awafi Store',
        debugShowCheckedModeBanner: false,
        
        // اللغات والترجمة
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        
        // الثيم الموحد
        theme: AppTheme.lightTheme,

        // التوجيه
        initialRoute: initialRoute,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}