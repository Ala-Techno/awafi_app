abstract class ApiConstants {
  const ApiConstants._();

  // ── Base URL ─────────────────────────────────────────────────────────────
  static const String apiBaseUrl = "https://api.awafi-store.com/v1/";

  // ── Auth Endpoints ─────────────────────────────────────────────────
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String refreshToken = "auth/refresh";
  static const String logout = "auth/logout";

  // ── Products Endpoints ─────────────────────────────────────────────
  static const String products = "products";
  static const String categories = "categories";
  static const String productsByCategory = "products?category=";
  static const String productSearch = "products/search?q=";

  // ── Cart Endpoints ─────────────────────────────────────────────────
  static const String carts = "cart";
  static const String userCart = "cart/user/";

  // ── Orders Endpoints ───────────────────────────────────────────────
  static const String orders = "orders";
  static const String userOrders = "orders/user/";
  static const String placeOrder = "orders/checkout";

  // ── Profile Endpoints ──────────────────────────────────────────────
  static const String userProfile = "users/profile";
  static const String updateProfile = "users/profile/update";
  static const String changePassword = "users/password/change";

  // ── Shipping & Payment Endpoints ───────────────────────────────────
  static const String shippingAddresses = "users/addresses";
  static const String paymentMethods = "users/payment-methods";

  // ── Local Storage Keys ─────────────────────────────────────────────
  static const String userTokenKey = "user_token";
  static const String refreshTokenKey = "refresh_token";
  static const String usernameKey = "username";
  static const String userIdKey = "user_id";
  static const String userEmailKey = "user_email";
  static const String orderHistoryKey = "order_history";
}