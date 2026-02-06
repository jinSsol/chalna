import 'game_mode.dart';

/// 게임 상태 열거형
enum GamePhase {
  /// 대기 상태: 화면을 탭하여 시작
  idle,

  /// 준비 상태: 빨간색 화면, 기다리세요
  ready,

  /// 신호 상태: 초록색 화면, 지금 탭하세요
  signal,

  /// 결과 상태: 반응 시간 표시
  result,

  /// 너무 빠름: 신호 전에 탭함
  tooFast,
}

/// 게임 상태
class GameState {
  final GamePhase phase;
  final GameMode mode;
  final int? reactionTimeMs;
  final List<int> continuousResults;
  final int currentRound;
  final bool isNewBestRecord;

  const GameState({
    this.phase = GamePhase.idle,
    this.mode = GameMode.classic,
    this.reactionTimeMs,
    this.continuousResults = const [],
    this.currentRound = 0,
    this.isNewBestRecord = false,
  });

  GameState copyWith({
    GamePhase? phase,
    GameMode? mode,
    int? reactionTimeMs,
    List<int>? continuousResults,
    int? currentRound,
    bool? isNewBestRecord,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      mode: mode ?? this.mode,
      reactionTimeMs: reactionTimeMs ?? this.reactionTimeMs,
      continuousResults: continuousResults ?? this.continuousResults,
      currentRound: currentRound ?? this.currentRound,
      isNewBestRecord: isNewBestRecord ?? this.isNewBestRecord,
    );
  }

  /// 연속 모드에서 평균 반응 시간 계산
  int? get averageReactionTime {
    if (continuousResults.isEmpty) return null;
    return (continuousResults.reduce((a, b) => a + b) / continuousResults.length)
        .round();
  }

  /// 연속 모드에서 최고 기록
  int? get bestContinuousResult {
    if (continuousResults.isEmpty) return null;
    return continuousResults.reduce((a, b) => a < b ? a : b);
  }

  /// 연속 모드에서 최저 기록
  int? get worstContinuousResult {
    if (continuousResults.isEmpty) return null;
    return continuousResults.reduce((a, b) => a > b ? a : b);
  }
}
