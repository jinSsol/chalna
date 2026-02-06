import 'package:flutter/services.dart';

/// 햅틱(진동) 피드백 서비스
class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool isEnabled = true;

  /// 가벼운 진동
  Future<void> lightImpact() async {
    if (!isEnabled) return;
    await HapticFeedback.lightImpact();
  }

  /// 중간 진동
  Future<void> mediumImpact() async {
    if (!isEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// 강한 진동
  Future<void> heavyImpact() async {
    if (!isEnabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// 선택 진동
  Future<void> selectionClick() async {
    if (!isEnabled) return;
    await HapticFeedback.selectionClick();
  }

  /// 성공 진동 패턴
  Future<void> successPattern() async {
    if (!isEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// 에러 진동 패턴
  Future<void> errorPattern() async {
    if (!isEnabled) return;
    await HapticFeedback.heavyImpact();
  }
}
