import 'package:awafi_app/app/routing/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // استخدام نمط Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // تهيئة المستمعات والإشعارات المحلية
  Future<void> initNotifications(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. طلب الصلاحيات
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    }

    // 2. إعدادات الإشعارات المحلية للأندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

   await _localNotificationsPlugin.initialize(
      settings: initializationSettings, // التصحيح هنا: استخدام settings بدلاً من initializationSettings
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        }
      },
    );

    // إنشاء قناة إشعارات خاصة بالأندرويد
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 3. طباعة التوكن للتحقق والتجربة
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // 4. الاستماع للإشعارات عندما يكون التطبيق مفتوحاً (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('A new onMessage event was published: ${message.notification?.title}');
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data['route'],
        );
      }
    });

    // 5. الاستماع عندما يتم الضغط على الإشعار والتطبيق في الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    // 6. التحقق إذا فتح التطبيق من حالة الإغلاق التام (Terminated) عبر إشعار
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationClick(initialMessage);
      });
    }
  }

  // دالة موحدة لتوجيه المستخدم بناءً على البيانات القادمة من الإشعار
  void _handleNotificationClick(RemoteMessage message) {
    final String? routeName = message.data['route'];
    final String? orderId = message.data['orderId'];

    if (routeName != null) {
      AppRouter.navigatorKey.currentState?.pushNamed(
        routeName,
        arguments: orderId,
      );
    }
  }
}