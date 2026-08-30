import 'package:awafi_app/features/auth/presentation/screens/login_page.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:awafi_app/features/home/presentation/screens/home_screen.dart';
import 'package:awafi_app/features/home/presentation/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:provider/provider.dart';
import '../../core/di/dependency_injection.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/providers/home_provider.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      
      // 1. مسار تسجيل الدخول (Login)
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<AuthProvider>(),
            child: const LoginPage(),
          ),
        );

      // 2. مسار الشاشة الرئيسية والمنتجات (Home)
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<HomeProvider>(),
            child: const HomeScreen(),
          ),
        );

      case Routes.productDetailsScreen:
        final product = settings.arguments as ProductEntity;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}