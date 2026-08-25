import 'package:flutter/material.dart';

/// Defines the Awafi brand color palette used throughout the application.
class AppColors {
  // Private constructor to prevent instantiation.
  const AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────

  /// Primary brand color — Crimson Red.
  static const Color primary = Color(0xFFD32F2F);

  /// Secondary / accent color — Leaf Green.
  static const Color secondary = Color(0xFF388E3C);

  // ── Backgrounds & Surfaces ───────────────────────────────────────────────

  /// App-wide scaffold background — Light Grey.
  static const Color background = Color(0xFFF9F9F9);

  /// Card and sheet surfaces — White.
  static const Color surface = Color(0xFFFFFFFF);

  // ── Typography ───────────────────────────────────────────────────────────

  /// Primary text color — Dark Grey.
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary / hint text color — Muted Grey.
  static const Color textSecondary = Color(0xFF757575);

  // ── Borders & Dividers ───────────────────────────────────────────────────

  /// Dividers, input borders, and separators — Light Border.
  static const Color border = Color(0xFFE0E0E0);

  // ── Feedback ─────────────────────────────────────────────────────────────

  /// Error state color — Bright Red.
  static const Color error = Color(0xFFB00020);
}
