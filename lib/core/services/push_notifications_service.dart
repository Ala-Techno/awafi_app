import 'package:awafi_app/app/routing/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PushNotificationsService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // مفتاح التنقل للتحكم بالصفحات من داخل الخدمة بدون الحاجة لـ context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> init() async {
    // 1. طلب الصلاحيات
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    }

   // 2. الحصول على التوكن الخاص بالجهاز
    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    await _firebaseMessaging.subscribeToTopic('orders');
    if (kDebugMode) {
      print('Subscribed to orders topic successfully');
    }
    // 3. الاستماع للرسائل والتطبيق مفتوح (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }
    });

    // 4. عندما يضغط المستخدم على الإشعار والتطبيق في الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message);
    });

    // 5. عندما يتم فتح التطبيق من الإغلاق التام (Terminated) عبر الضغط على الإشعار
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessageNavigation(initialMessage);
      });
    }
  }

  // دالة التوجيه عند الضغط على الإشعار
static void _handleMessageNavigation(RemoteMessage message) {
    if (kDebugMode) {
      print('A new onMessageOpenedApp event was published!');
      print('Data: ${message.data}');
    }

    String? screenType = message.data['screen'];

    // إذا كانت القيمة المرسلة من فايربيس تخص الطلبات أو التاريخ
    if (screenType == 'order_details' || screenType == 'orders') {
      navigatorKey.currentState?.pushNamed(Routes.ordersHistoryScreen);
    }
  }
}