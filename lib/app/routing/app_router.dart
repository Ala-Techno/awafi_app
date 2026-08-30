import 'package:awafi_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:awafi_app/features/auth/presentation/screens/home_page.dart';
import 'package:awafi_app/features/auth/presentation/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:provider/provider.dart';
import '../../core/di/dependency_injection.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
    case Routes.loginScreen:
        return MaterialPageRoute(
  builder: (_) => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authRepository: getIt<AuthRepository>()),
      ),
    ],
    child: const LoginPage(),
  ),
);
  
case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
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