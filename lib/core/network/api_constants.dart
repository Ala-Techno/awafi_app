abstract class ApiConstants {
  const ApiConstants._();

  // ── Base URL ─────────────────────────────────────────────────────────────
  static const String apiBaseUrl = "https://fakestoreapi.com/"; 

  // ── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = "auth/login";

  // ── Home & Products Endpoints ────────────────────────────────────────────
  static const String products = "products";
  static const String categories = "products/categories";

  // ── Cart Endpoints ───────────────────────────────────────────────────────
  static const String carts = "carts";
  static const String userCart = "carts/user/"; // ترفق معها الـ userId

  // ── Local Storage Keys ───────────────────────────────────────────────────
  static const String userTokenKey = "user_token";
}