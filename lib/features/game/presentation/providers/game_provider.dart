import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/game_repository.dart';
import '../../domain/game_mode.dart';
import '../../domain/game_state.dart';
import '../../../records/presentation/providers/records_provider.dart';

/// 선택된 게임 모드 Provider
final selectedGameModeProvider = StateProvider<GameMode>((ref) => GameMode.classic);

/// 게임 레포지토리 Provider
final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepository());

/// 게임 상태 Provider
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});

/// 게임 상태 관리 Notifier
class GameStateNotifier extends StateNotifier<GameState> {
  final Ref _ref;
  final HapticService _hapticService = HapticService();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _waitTimer;

  GameStateNotifier(this._ref) : super(const GameState());

  /// 게임 초기화
  void initialize(GameMode mode) {
    _waitTimer?.cancel();
    _stopwatch.reset();
    state = GameState(mode: mode, phase: GamePhase.idle);
  }

  /// 게임 시작 (대기 → 준비)
  void startGame() {
    if (state.phase != GamePhase.idle) return;

    state = state.copyWith(phase: GamePhase.ready);
    _hapticService.lightImpact();

    // 랜덤 대기 시간 후 신호 표시
    final waitTime = _ref.read(gameRepositoryProvider).generateWaitTime();
    _waitTimer = Timer(Duration(milliseconds: waitTime), _showSignal);
  }

  /// 신호 표시 (준비 → 신호)
  void _showSignal() {
    if (state.phase != GamePhase.ready) return;

    _stopwatch.start();
    state = state.copyWith(phase: GamePhase.signal);
    _hapticService.mediumImpact();
  }

  /// 화면 탭 처리
  Future<void> onTap() async {
    switch (state.phase) {
      case GamePhase.idle:
        startGame();
        break;
      case GamePhase.ready:
        // 너무 빨리 탭함
        _waitTimer?.cancel();
        state = state.copyWith(phase: GamePhase.tooFast);
        _hapticService.errorPattern();
        break;
      case GamePhase.signal:
        // 반응 시간 측정
        _stopwatch.stop();
        final reactionTime = _stopwatch.elapsedMilliseconds;
        await _handleResult(reactionTime);
        break;
      case GamePhase.result:
      case GamePhase.tooFast:
        // 무시
        break;
    }
  }

  /// 결과 처리
  Future<void> _handleResult(int reactionTimeMs) async {
    _hapticService.successPattern();

    if (state.mode == GameMode.continuous) {
      final newResults = [...state.continuousResults, reactionTimeMs];
      final newRound = state.currentRound + 1;

      if (newRound < AppConfig.continuousModeRounds) {
        // 다음 라운드
        state = state.copyWith(
          continuousResults: newResults,
          currentRound: newRound,
          phase: GamePhase.idle,
        );
        _stopwatch.reset();
      } else {
        // 모든 라운드 완료
        final avgTime =
            (newResults.reduce((a, b) => a + b) / newResults.length).round();
        final isNewBest = await _ref
            .read(recordsProvider.notifier)
            .addRecord(avgTime, state.mode);

        state = state.copyWith(
          continuousResults: newResults,
          currentRound: newRound,
          reactionTimeMs: avgTime,
          phase: GamePhase.result,
          isNewBestRecord: isNewBest,
        );
      }
    } else {
      // 단일 게임 (클래식/랜덤 모드)
      final isNewBest = await _ref
          .read(recordsProvider.notifier)
          .addRecord(reactionTimeMs, state.mode);

      state = state.copyWith(
        reactionTimeMs: reactionTimeMs,
        phase: GamePhase.result,
        isNewBestRecord: isNewBest,
      );
    }
  }

  /// 게임 리셋
  void reset() {
    _waitTimer?.cancel();
    _stopwatch.reset();
    state = GameState(
      mode: state.mode,
      phase: GamePhase.idle,
    );
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }
}
