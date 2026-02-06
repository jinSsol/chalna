/// 게임 모드 열거형
enum GameMode {
  /// 클래식 모드: 빨간→초록 색상 변화 감지 후 탭
  classic,

  /// 랜덤 모드: 랜덤한 대기 시간 (1~5초)
  random,

  /// 연속 모드: 5회 연속 측정 후 평균값
  continuous,
}
