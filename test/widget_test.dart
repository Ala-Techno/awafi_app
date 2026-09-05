import 'package:awafi_app/app/routing/app_router.dart';
import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/di/dependency_injection.dart';
import 'package:awafi_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('SplashScreen smoke test displays logo and indicator', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    if (!getIt.isRegistered<SharedPreferences>()) {
      await setupGetIt();
    }

    final appRouter = AppRouter();

    await tester.pumpWidget(MaterialApp(
      initialRoute: Routes.splashScreen,
      onGenerateRoute: appRouter.generateRoute,
    ));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });
}
