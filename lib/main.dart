import 'package:awafi_app/core/localization/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'core/theme/app_theme.dart';
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awafi Store',
      debugShowCheckedModeBanner: false,

      // ── إعدادات الترجمة واللغات ──────────────────────────────────────────────
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

  // ── الثيم الموحد للخط والألوان ──────────────────────────────────────────
      theme: AppTheme.lightTheme,

      home: const _PlaceholderScreen(),
    );
  }
}

/// Temporary placeholder screen — will be replaced by the router entry point.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
    appBar: AppBar(title: Text(AppStrings.welcome)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 72,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Awafi Store',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clean Architecture · Feature-First',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
