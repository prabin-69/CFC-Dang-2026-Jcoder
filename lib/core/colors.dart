import 'package:flutter/material.dart';

/// Premium design system colors for WorkLink.
///
/// Inspired by Airbnb, Uber, and LinkedIn — professional blue primary,
/// emerald green secondary, gold accent, and full dark theme support.
class AppColors {
  // ──────────────────────────────────────────────
  //  PRIMARY PALETTE — Professional Blue (#1565C0)
  // ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);
  static const Color primaryContainer = Color(0xFFD1E4FF);
  static const Color primaryOnContainer = Color(0xFF001D36);

  // ──────────────────────────────────────────────
  //  SECONDARY PALETTE — Emerald Green
  // ──────────────────────────────────────────────
  static const Color secondary = Color(0xFF00BFA5);
  static const Color secondaryLight = Color(0xFF5DF2D6);
  static const Color secondaryDark = Color(0xFF008E76);
  static const Color secondaryContainer = Color(0xFFB2DFDB);

  // ──────────────────────────────────────────────
  //  ACCENT — Gold / Amber
  // ──────────────────────────────────────────────
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFE54C);
  static const Color accentContainer = Color(0xFFFFF8E1);

  // ──────────────────────────────────────────────
  //  SURFACES — Light
  // ──────────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color surfaceContainerLow = Color(0xFFF8F9FE);
  static const Color surfaceContainerHigh = Color(0xFFEEF0F6);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  //  SURFACES — Dark
  // ──────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);
  static const Color darkCardBackground = Color(0xFF1C2128);

  // ──────────────────────────────────────────────
  //  TEXT — Light
  // ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F1419);
  static const Color textSecondary = Color(0xFF536471);
  static const Color textHint = Color(0xFF8B98A5);
  static const Color textDisabled = Color(0xFFB0B8C1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF1A1A2E);

  // ──────────────────────────────────────────────
  //  TEXT — Dark
  // ──────────────────────────────────────────────
  static const Color darkTextPrimary = Color(0xFFE1E8ED);
  static const Color darkTextSecondary = Color(0xFF8B98A5);
  static const Color darkTextHint = Color(0xFF5C6B7A);

  // ──────────────────────────────────────────────
  //  STATUS COLORS
  // ──────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ──────────────────────────────────────────────
  //  RATING
  // ──────────────────────────────────────────────
  static const Color ratingActive = Color(0xFFFFB800);
  static const Color ratingInactive = Color(0xFFD1D5DB);

  // ──────────────────────────────────────────────
  //  BORDERS & DIVIDERS
  // ──────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color darkBorder = Color(0xFF30363D);

  // ──────────────────────────────────────────────
  //  SHIMMER
  // ──────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ──────────────────────────────────────────────
  //  GRADIENTS
  // ──────────────────────────────────────────────
  static const List<Color> primaryGradient = [
    Color(0xFF1565C0),
    Color(0xFF1976D2),
  ];
  static const List<Color> primaryGradientDeep = [
    Color(0xFF0D47A1),
    Color(0xFF1565C0),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF00BFA5),
    Color(0xFF1DE9B6),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFFB300),
    Color(0xFFFFCA28),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF161B22),
    Color(0xFF0D1117),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];

  // ──────────────────────────────────────────────
  //  SHADOW
  // ──────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> strongShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.15),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];
}
