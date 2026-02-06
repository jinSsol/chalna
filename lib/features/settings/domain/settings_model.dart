import 'package:flutter/material.dart';

/// 설정 모델
class SettingsModel {
  final bool vibrationEnabled;
  final bool soundEnabled;
  final ThemeMode themeMode;

  const SettingsModel({
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  SettingsModel copyWith({
    bool? vibrationEnabled,
    bool? soundEnabled,
    ThemeMode? themeMode,
  }) {
    return SettingsModel(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'themeMode': themeMode.index,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
    );
  }
}
