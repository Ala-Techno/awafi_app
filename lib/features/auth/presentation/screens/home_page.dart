import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/di/dependency_injection.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية (تجريبية)'),
        automaticallyImplyLeading: false, // يمنع إظهار زر الرجوع
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
    // 1. مسح التوكن من الذاكرة المحلية
    await getIt<SharedPrefService>().removeData(ApiConstants.userTokenKey);

    // 2. التوجيه لصفحة الدخول وحذف الـ Stack
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreen,
        (route) => false,
      );
    }
  },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'تم تسجيل الدخول بنجاح! 🎉',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'أهلاً بك في تطبيق عوافي',
              style: TextStyle(color: Colors.grey),
            ),
            
          ],
        ),
      ),
    );
  }
}