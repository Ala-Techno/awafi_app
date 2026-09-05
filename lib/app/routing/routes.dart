abstract class Routes {
  const Routes._();

  // ── Entry Point ──────────────────────────────────────────────────────────
  static const String splashScreen = '/';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String loginScreen = '/loginScreen';

  // ── Main App Screens ─────────────────────────────────────────────────────
  static const String homeScreen = '/homeScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String catalogScreen = '/catalogScreen';

  // ── Cart & Checkout Flow ─────────────────────────────────────────────────
  static const String cartScreen = '/cartScreen';
  static const String checkoutScreen = '/checkoutScreen';
  static const String orderSuccessScreen = '/orderSuccessScreen';

  // ── Profile & Orders ─────────────────────────────────────────────────────
  static const String profileScreen = '/profileScreen';
  static const String ordersHistoryScreen = '/ordersHistoryScreen';
}