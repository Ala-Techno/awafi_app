/// Stores all API endpoints and network-related constants.
abstract class ApiConstants {
  // Private constructor to prevent instantiation.
  const ApiConstants._();

  // ── Base URL ─────────────────────────────────────────────────────────────
  static const String apiBaseUrl = "https://v1.user-api.com/"; // رابط السيرفر الرئيسي

  // ── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String refreshToken = "auth/refresh-token";

  // ── Home & Products Endpoints ────────────────────────────────────────────
  static const String products = "products";
  static const String categories = "categories";
}