import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/dependency_injection.dart';
import 'routes.dart';

// Screens & Providers
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';

import '../../features/home/domain/entities/product_entity.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/product_details_screen.dart';

import '../../features/catalog/presentation/providers/catalog_provider.dart';
import '../../features/catalog/presentation/screens/catalog_screen.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';

import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/orders/presentation/screens/checkout_screen.dart';
import '../../features/orders/presentation/screens/order_success_screen.dart';
import '../../features/orders/presentation/screens/orders_history_screen.dart';

import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // 0. شاشة البداية (Splash)
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      // 1. شاشة تسجيل الدخول (Login)
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<AuthProvider>(),
            child: const LoginPage(),
          ),
        );

      // 2. الشاشة الرئيسية والمنتجات (Home)
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<HomeProvider>(),
            child: const HomeScreen(),
          ),
        );

      // 3. شاشة تفاصيل المنتج (Product Details)
      case Routes.productDetailsScreen:
        final product = settings.arguments as ProductEntity;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      // 4. شاشة تصفح الأقسام (Catalog)
      case Routes.catalogScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<CatalogProvider>(),
            child: const CatalogScreen(),
          ),
        );

      // 5. شاشة السلة (Cart)
      case Routes.cartScreen:
        final userId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => CartScreen(userId: userId),
        );

      // 6. شاشة إتمام الطلب والدفع (Checkout)
      case Routes.checkoutScreen:
        final userId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<OrdersProvider>(),
            child: CheckoutScreen(userId: userId),
          ),
        );

      // 7. شاشة نجاح الطلب (Order Success)
      case Routes.orderSuccessScreen:
        final order = settings.arguments as OrderEntity?;
        return MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order),
        );

      // 8. شاشة سجل الطلبات السابقة (Orders History)
      case Routes.ordersHistoryScreen:
        final userId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<OrdersProvider>(),
            child: OrdersHistoryScreen(userId: userId),
          ),
        );

      // 9. شاشة الملف الشخصي (Profile)
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<ProfileProvider>(),
            child: const ProfileScreen(),
          ),
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