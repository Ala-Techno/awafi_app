/// Centralized repository for all asset paths used in the application.
abstract class AppAssets {
  // Private constructor to prevent instantiation.
  const AppAssets._();

  // ── Base Paths ──────────────────────────────────────────────────────────
  static const String _imagesPath = 'assets/images';
  // static const String _svgsPath = 'assets/svgs'; // في حال استخدمنا SVG لاحقاً

  // ── Images ──────────────────────────────────────────────────────────────
  static const String appLogo = '$_imagesPath/app_logo.png';
  static const String onboardingHeader = '$_imagesPath/onboarding_header.png';
  static const String placeholder = '$_imagesPath/placeholder.png';

  // ── Icons / SVGs (إن وجدت) ────────────────────────────────────────────────
  // static const String icGoogle = '$_svgsPath/ic_google.svg';
}