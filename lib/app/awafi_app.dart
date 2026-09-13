import 'package:awafi_app/core/di/dependency_injection.dart';
import 'package:awafi_app/core/services/push_notifications_service.dart';
import 'package:awafi_app/core/theme/app_theme.dart';
import 'package:awafi_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:awafi_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:awafi_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:awafi_app/features/home/presentation/providers/home_provider.dart';
import 'package:awafi_app/features/profile/presentation/providers/profile_provider.dart';
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
        // 1. السلة
        ChangeNotifierProvider(
          create: (_) => getIt<CartController>(),
        ),
        
        // 2. المصادقة
        ChangeNotifierProvider(
          create: (_) => getIt<AuthProvider>(),
        ),

        // 3. الرئيسية (البانرات والمنتجات)
        ChangeNotifierProvider(
          create: (_) => getIt<HomeProvider>(),
        ),

        // 4. الأقسام والكتالوج
        ChangeNotifierProvider(
          create: (_) => getIt<CatalogProvider>(),
        ),

        // 5. الملف الشخصي
        ChangeNotifierProvider(
          create: (_) => getIt<ProfileProvider>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: PushNotificationsService.navigatorKey, // أضف هذا السطر هنا
        title: 'Awafi App',
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