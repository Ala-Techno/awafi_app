abstract class Routes {
  const Routes._();

  // ── Entry Point ──────────────────────────────────────────────────────────
  static const String splashScreen = '/';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';  
  // ── Main App Screens ─────────────────────────────────────────────────────
  static const String homeScreen = '/homeScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String catalogScreen = '/catalogScreen';
  static const String mainNavigationScreen = '/mainNavigationScreen';
  static const String searchScreen = '/searchScreen';

  // ── Cart & Checkout Flow ─────────────────────────────────────────────────
  static const String cartScreen = '/cartScreen';
  static const String checkoutScreen = '/checkoutScreen';
  static const String orderSuccessScreen = '/orderSuccessScreen';
  // static const String orderDetailsScreen = '/orderDetailsScreen';
  // ── Profile & Orders ─────────────────────────────────────────────────────
  static const String profileScreen = '/profileScreen';
  static const String ordersHistoryScreen = '/ordersHistoryScreen';
}