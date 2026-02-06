import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_config.dart';
import '../domain/settings_model.dart';

/// 설정 레포지토리
class SettingsRepository {
  SharedPreferences? _prefs;

  /// 초기화
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 설정 로드
  SettingsModel loadSettings() {
    if (_prefs == null) return const SettingsModel();

    return SettingsModel(
      vibrationEnabled: _prefs!.getBool(AppConfig.vibrationKey) ?? true,
      soundEnabled: _prefs!.getBool(AppConfig.soundKey) ?? true,
      themeMode: ThemeMode.values[_prefs!.getInt(AppConfig.themeModeKey) ?? 0],
    );
  }

  /// 설정 저장
  Future<void> saveSettings(SettingsModel settings) async {
    await _prefs?.setBool(AppConfig.vibrationKey, settings.vibrationEnabled);
    await _prefs?.setBool(AppConfig.soundKey, settings.soundEnabled);
    await _prefs?.setInt(AppConfig.themeModeKey, settings.themeMode.index);
  }

  /// 진동 설정 저장
  Future<void> setVibration(bool enabled) async {
    await _prefs?.setBool(AppConfig.vibrationKey, enabled);
  }

  /// 사운드 설정 저장
  Future<void> setSound(bool enabled) async {
    await _prefs?.setBool(AppConfig.soundKey, enabled);
  }

  /// 테마 모드 저장
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs?.setInt(AppConfig.themeModeKey, mode.index);
  }
}
