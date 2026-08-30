/// Stores all API endpoints and network-related constants.
abstract class ApiConstants {
  const ApiConstants._();

  // ── Base URL ─────────────────────────────────────────────────────────────
  static const String apiBaseUrl = "https://reqres.in/api/"; 

  // ── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = "login";
  static const String register = "register";

  // ── Home & Products Endpoints ────────────────────────────────────────────
  static const String products = "unknown";
  static const String categories = "users";

  // ── Local Storage Keys ───────────────────────────────────────────────────
  static const String userTokenKey = "user_token";
}