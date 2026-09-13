import 'package:awafi_app/app/awafi_app.dart';
import 'package:awafi_app/app/routing/app_router.dart';
import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/services/notification_service.dart';
import 'package:awafi_app/core/services/push_notifications_service.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // هذه الدالة تعمل في الخلفية عندما يكون التطبيق مغلقاً كلياً
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // 1. تأكيد تهيئة محرك فلاتر قبل أي خدمة
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تفعيل مكتبة الترجمة
  await EasyLocalization.ensureInitialized();

  // التحقق من عدم تكرار التهيئة لمنع انهيار التطبيق
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase already initialized or error: $e");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 
  // 3. تشغيل حقن التبعيات
  await setupGetIt();
  // 2. استدعاء خدمة الإشعارات وتمرير مفتاح الراوتر لها
  final notificationService = getIt<NotificationService>();
  await notificationService.initNotifications(AppRouter.navigatorKey);

// تفعيل خدمة الإشعارات
  await PushNotificationsService.init();
  // 4. البداية دائماً من شاشة البداية (Splash Screen)
  const String initialRoute = Routes.splashScreen;

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
