import 'package:flutter/material.dart';

/// Omra Companion — Palette de couleurs premium
/// Inspirée de l'identité visuelle islamique avec des tons émeraude et or.
class AppColors {
  AppColors._();

  // ──── PRIMARY COLORS ────
  /// Emerald Green - Couleur principale
  static const Color primaryGreen = Color(0xFF0E8C43);

  /// Lime Green - Couleur secondaire
  static const Color secondaryGreen = Color(0xFF8DC63F);

  /// Glow Gold - Couleur d'accent
  static const Color accentGold = Color(0xFFFFB800);

  // ──── BACKGROUND COLORS ────
  /// Light mode background
  static const Color lightBackground = Color(0xFFF4F7F5);

  /// Dark mode background - Deep Islamic Dark Green
  static const Color darkBackground = Color(0xFF0B1E14);

  /// Card background for light mode
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  /// Card background for dark mode
  static const Color darkCardBackground = Color(0xFF142E1E);

  // ──── SURFACE COLORS ────
  /// Light surface variant
  static const Color lightSurface = Color(0xFFE8F0EB);

  /// Dark surface variant
  static const Color darkSurface = Color(0xFF1A3D28);

  // ──── TEXT COLORS ────
  /// Primary text on light background
  static const Color lightTextPrimary = Color(0xFF1A1A2E);

  /// Secondary text on light background
  static const Color lightTextSecondary = Color(0xFF6B7280);

  /// Primary text on dark background
  static const Color darkTextPrimary = Color(0xFFF4F7F5);

  /// Secondary text on dark background
  static const Color darkTextSecondary = Color(0xFFA3B8A9);

  // ──── GRADIENT DEFINITIONS ────
  /// Primary gradient for buttons and headers
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, secondaryGreen],
  );

  /// Gold accent gradient for premium elements
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
  );

  /// Dark overlay gradient for cards
  static const LinearGradient darkOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x99000000)],
  );

  // ──── STATUS COLORS ────
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF60A5FA);
}
