/// 앱 전체에서 사용되는 문자열 상수
class AppStrings {
  AppStrings._();

  // App info
  static const String appName = '찰나';
  static const String appSubtitle = '반응속도 테스트';
  static const String appVersion = '1.0.0';

  // Home screen
  static const String start = '시작';
  static const String bestRecord = '최고 기록';
  static const String settings = '설정';
  static const String records = '기록';

  // Game modes
  static const String classicMode = '클래식';
  static const String randomMode = '랜덤';
  static const String continuousMode = '연속';

  // Game states
  static const String tapToStart = '화면을 탭하여 시작';
  static const String wait = '기다리세요...';
  static const String tapNow = '지금!';
  static const String tooFast = '너무 빨라요!';
  static const String waitForGreen = '초록색이 될 때까지\n기다리세요';

  // Result screen
  static const String retry = '다시하기';
  static const String share = '공유하기';
  static const String newBestRecord = '새로운 최고 기록!';
  static const String reactionTime = '반응 시간';
  static const String ms = 'ms';

  // Grades
  static const String gradeLightning = '번개';
  static const String gradeVeryFast = '매우 빠름';
  static const String gradeFast = '빠름';
  static const String gradeNormal = '보통';
  static const String gradeSlow = '느림';

  // Records screen
  static const String recentRecords = '최근 기록';
  static const String averageTime = '평균';
  static const String totalPlays = '총 플레이';
  static const String grade = '등급';

  // Settings screen
  static const String vibration = '진동';
  static const String sound = '사운드';
  static const String theme = '테마';
  static const String systemTheme = '시스템';
  static const String lightTheme = '라이트';
  static const String darkTheme = '다크';
  static const String resetRecords = '기록 초기화';
  static const String resetConfirm = '정말로 모든 기록을 초기화하시겠습니까?';
  static const String cancel = '취소';
  static const String confirm = '확인';

  // Continuous mode
  static const String round = '라운드';
  static const String average = '평균';
  static const String best = '최고';
  static const String worst = '최저';

  // Share
  static const String shareTitle = '찰나 반응속도 테스트';
  static const String shareText = '내 반응속도: {time}ms ({grade})\n너는 얼마나 빠를까?';

  // Time display
  static const String justNow = '방금 전';
  static const String minutesAgo = '{n}분 전';
  static const String hoursAgo = '{n}시간 전';
  static const String daysAgo = '{n}일 전';
}
