/// 앱 설정 상수
class AppConfig {
  AppConfig._();

  // Game config
  static const int minWaitTime = 1000; // 최소 대기 시간 (ms)
  static const int maxWaitTime = 5000; // 최대 대기 시간 (ms)
  static const int continuousModeRounds = 5; // 연속 모드 라운드 수

  // Grade thresholds (ms)
  static const int gradeLightningThreshold = 150;
  static const int gradeVeryFastThreshold = 200;
  static const int gradeFastThreshold = 250;
  static const int gradeNormalThreshold = 300;

  // Records config
  static const int maxRecentRecords = 10;

  // Ad config
  static const int interstitialAdInterval = 3; // 전면 광고 표시 간격 (게임 횟수)

  // AdMob config (Test IDs - replace with real IDs for production)
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910';

  // Storage keys
  static const String settingsBox = 'settings';
  static const String recordsBox = 'records';

  // Settings keys
  static const String vibrationKey = 'vibration';
  static const String soundKey = 'sound';
  static const String themeModeKey = 'themeMode';
}
