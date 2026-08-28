import 'package:easy_localization/easy_localization.dart';

/// Manages and exposes localized string keys used throughout the application.
abstract class AppStrings {
  // Private constructor to prevent instantiation.
  const AppStrings._();

  // ── Auth & Account ───────────────────────────────────────────────────────
  static String get login => 'login'.tr();
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get welcomeBack => 'welcome_back'.tr();

  // ── Network & General Errors ────────────────────────────────────────────
  static String get serverError => 'server_error'.tr();
  static String get noInternet => 'no_internet'.tr();
  static String get unknownError => 'unknown_error'.tr();

  // ── Welcom Screen ─────────────────────────────────────────────────────────
  static String get welcome => 'welcome'.tr();
}