import 'package:awafi_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'routing/app_router.dart';
import 'routing/routes.dart';


class AwafiApp extends StatelessWidget {
  final AppRouter appRouter;
  const AwafiApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awafi Store',
      debugShowCheckedModeBanner: false,
      
      // اللغات والترجمة
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      
      // الثيم الموحد
      theme: AppTheme.lightTheme,

      // التوجيه
      initialRoute: Routes.loginScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}