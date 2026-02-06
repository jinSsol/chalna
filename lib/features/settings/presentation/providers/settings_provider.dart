import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/settings_repository.dart';
import '../../domain/settings_model.dart';

/// 설정 레포지토리 Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// 설정 상태 Provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});

/// 테마 모드 Provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

/// 설정 관리 Notifier
class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsRepository _repository;
  bool _isInitialized = false;

  SettingsNotifier(this._repository) : super(const SettingsModel());

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _repository.initialize();
    state = _repository.loadSettings();
    _isInitialized = true;

    // 햅틱 서비스 설정 동기화
    HapticService().isEnabled = state.vibrationEnabled;
  }

  /// 진동 설정 변경
  Future<void> setVibration(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _repository.setVibration(enabled);
    HapticService().isEnabled = enabled;
  }

  /// 사운드 설정 변경
  Future<void> setSound(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _repository.setSound(enabled);
  }

  /// 테마 모드 변경
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.setThemeMode(mode);
  }
}
