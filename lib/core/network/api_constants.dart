/// Stores all API endpoints and network-related constants.


// //    خاص ب تسجيل الدخول 
// //----------------------------

// abstract class ApiConstants {
//   const ApiConstants._();

//   // ── Base URL ─────────────────────────────────────────────────────────────
//   static const String apiBaseUrl = "https://reqres.in/api/"; 

//   // ── Auth Endpoints ───────────────────────────────────────────────────────
//   static const String login = "login";
//   static const String register = "register";

//   // ── Home & Products Endpoints ────────────────────────────────────────────
//   static const String products = "unknown";
//   static const String categories = "users";

//   // ── Local Storage Keys ───────────────────────────────────────────────────
//   static const String userTokenKey = "user_token";
// }


//    خاص ب منتجات
//----------------------------

abstract class ApiConstants {
  const ApiConstants._();

  // ── Base URL ─────────────────────────────────────────────────────────────
  // التغيير هنا: استخدام سيرفر المنتجات Fakestoreapi
  static const String apiBaseUrl = "https://fakestoreapi.com/"; 

  // ── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = "auth/login";

  // ── Home & Products Endpoints ────────────────────────────────────────────
  static const String products = "products";
  static const String categories = "products/categories";

  // ── Local Storage Keys ───────────────────────────────────────────────────
  static const String userTokenKey = "user_token";
}