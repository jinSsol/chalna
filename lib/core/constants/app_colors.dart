import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 색상 상수 - 미니멀 모던 테마
class AppColors {
  AppColors._();

  // Primary colors - 모던 틸/민트
  static const Color primary = Color(0xFF2DD4BF);
  static const Color primaryDark = Color(0xFF14B8A6);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accent = Color(0xFF22D3EE);

  // Game state colors
  static const Color waiting = Color(0xFFF1F5F9);
  static const Color ready = Color(0xFFFB7185);
  static const Color signal = Color(0xFF2DD4BF);
  static const Color tooFast = Color(0xFFFBBF24);

  // Grade colors - 모던 팔레트
  static const Color gradeLightning = Color(0xFFFBBF24);
  static const Color gradeVeryFast = Color(0xFFF472B6);
  static const Color gradeFast = Color(0xFF2DD4BF);
  static const Color gradeNormal = Color(0xFF60A5FA);
  static const Color gradeSlow = Color(0xFF94A3B8);

  // Background colors - 깔끔한 화이트/그레이 베이스
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // Primary gradient
  static const List<Color> primaryGradient = [
    Color(0xFF2DD4BF),
    Color(0xFF22D3EE),
  ];

  // Success gradient
  static const List<Color> successGradient = [
    Color(0xFF2DD4BF),
    Color(0xFF14B8A6),
  ];

  // Danger gradient
  static const List<Color> dangerGradient = [
    Color(0xFFFB7185),
    Color(0xFFF43F5E),
  ];

  // Header gradient (legacy support)
  static const List<Color> headerGradient = primaryGradient;

  // Text colors - 모던 그레이 스케일
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textPrimaryLight = textPrimary;
  static const Color textSecondaryLight = textSecondary;
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status colors
  static const Color error = Color(0xFFF43F5E);
  static const Color success = Color(0xFF2DD4BF);
  static const Color warning = Color(0xFFFBBF24);

  // Shadow
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x40000000);

  // Legacy support
  static const Color glassLight = Color(0xB3FFFFFF);
  static const Color glassDark = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);

  // Glassmorphism gradient backgrounds - 틸/민트 톤 유지
  static const List<Color> glassBackgroundGradient = [
    Color(0xFFE0F7F5), // soft mint
    Color(0xFFD5F0EE), // light teal
    Color(0xFFE8F8F7), // pale cyan
    Color(0xFFD0EFED), // muted teal
  ];

  static const List<Color> glassBackgroundGradientDark = [
    Color(0xFF0A1F1D),
    Color(0xFF0D1A19),
    Color(0xFF0F2120),
    Color(0xFF0B1917),
  ];

  // Glass card colors
  static const Color glassCardLight2 = Color(0xCCFFFFFF);
  static const Color glassCardDark2 = Color(0x33FFFFFF);
  static const Color glassCardBorderLight = Color(0x66FFFFFF);
  static const Color glassCardBorderDark = Color(0x33FFFFFF);
}
