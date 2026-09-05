import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/di/dependency_injection.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:awafi_app/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final sharedPref = getIt<SharedPrefService>();
    final String token = sharedPref.getString(ApiConstants.userTokenKey);

    if (token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 52,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'عوافي',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
