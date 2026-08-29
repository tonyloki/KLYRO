import 'package:flutter/material.dart';

class AppColors {
  // Core Backgrounds
  static const Color background = Color(0xFF0B0D11);
  static const Color surface = Color(0xFF12161F);
  static const Color surfaceElevated = Color(0xFF181D29);
  static const Color surfaceCard = Color(0xFF141924);
  static const Color border = Color(0xFF222938);
  static const Color borderLight = Color(0xFF2E384D);

  // Brand & Semantic Accents
  static const Color primary = Color(0xFF00FF88); // Electric Green
  static const Color primaryDim = Color(0xFF00C968);
  static const Color failure = Color(0xFFFF4D4D); // Muted Red
  static const Color warning = Color(0xFFF59E0B); // Amber / Hypothesis
  static const Color ai = Color(0xFF8B5CF6);      // AI Purple Reasoning
  static const Color info = Color(0xFF38BDF8);    // Information Blue
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDim = Color(0xFF475569);

  // Code & Diff Highlights
  static const Color codeBackground = Color(0xFF07090C);
  static const Color diffAddBg = Color(0x2400FF88);
  static const Color diffAddBorder = Color(0xFF00FF88);
  static const Color diffRemoveBg = Color(0x24FF4D4D);
  static const Color diffRemoveBorder = Color(0xFFFF4D4D);
  static const Color codeSuspiciousBg = Color(0x33F59E0B);
  static const Color codeSuspiciousBorder = Color(0xFFF59E0B);
}
