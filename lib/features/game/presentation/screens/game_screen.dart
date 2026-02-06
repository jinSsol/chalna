import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/share_service.dart';
import '../../data/game_repository.dart';
import '../../domain/game_mode.dart';
import '../../domain/game_state.dart';
import '../providers/game_provider.dart';
import '../widgets/tap_area.dart';
import '../widgets/result_card.dart';
import '../widgets/continuous_result_card.dart';

/// 게임 완료 횟수 카운터 (전면 광고 표시용, 앱 세션 동안 유지)
int _gameCompletionCount = 0;

/// 게임 화면
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with WidgetsBindingObserver {
  bool _adShownForCurrentResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 게임 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mode = ref.read(selectedGameModeProvider);
      ref.read(gameStateProvider.notifier).initialize(mode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 백그라운드 진입 시 게임 리셋
    if (state == AppLifecycleState.paused) {
      ref.read(gameStateProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final gameRepository = ref.watch(gameRepositoryProvider);

    return PopScope(
      canPop: gameState.phase == GamePhase.idle ||
          gameState.phase == GamePhase.result,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 게임 중이면 리셋하고 나가기
          ref.read(gameStateProvider.notifier).reset();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context, gameState),
        body: _buildBody(context, gameState, gameRepository),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, GameState gameState) {
    // 게임 중에는 앱바 숨김
    if (gameState.phase == GamePhase.ready ||
        gameState.phase == GamePhase.signal) {
      return null;
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref.read(gameStateProvider.notifier).reset();
          context.pop();
        },
      ),
      title: Text(_getModeTitle(gameState.mode)),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GameState gameState,
    GameRepository gameRepository,
  ) {
    // 결과 화면
    if (gameState.phase == GamePhase.result) {
      if (!_adShownForCurrentResult) {
        _adShownForCurrentResult = true;
        _gameCompletionCount++;
        if (_gameCompletionCount % AppConfig.interstitialAdInterval == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AdService().showInterstitialAd();
          });
        }
      }
      return _buildResultView(context, gameState, gameRepository);
    } else {
      _adShownForCurrentResult = false;
    }

    // 게임 영역
    return TapArea(
      phase: gameState.phase,
      onTap: () => _handleTap(gameState),
      currentRound:
          gameState.mode == GameMode.continuous ? gameState.currentRound : null,
      totalRounds: gameState.mode == GameMode.continuous
          ? AppConfig.continuousModeRounds
          : null,
    );
  }

  Widget _buildResultView(
    BuildContext context,
    GameState gameState,
    GameRepository gameRepository,
  ) {
    final reactionTime = gameState.reactionTimeMs!;
    final gradeInfo = gameRepository.getGradeInfo(reactionTime);

    if (gameState.mode == GameMode.continuous) {
      return Center(
        child: SingleChildScrollView(
          child: ContinuousResultCard(
            results: gameState.continuousResults,
            averageTime: reactionTime,
            bestTime: gameState.bestContinuousResult!,
            worstTime: gameState.worstContinuousResult!,
            gradeInfo: gradeInfo,
            isNewBestRecord: gameState.isNewBestRecord,
            onRetry: _handleRetry,
            onShare: () => _handleShare(reactionTime, gradeInfo),
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: ResultCard(
          reactionTimeMs: reactionTime,
          gradeInfo: gradeInfo,
          isNewBestRecord: gameState.isNewBestRecord,
          onRetry: _handleRetry,
          onShare: () => _handleShare(reactionTime, gradeInfo),
        ),
      ),
    );
  }

  void _handleTap(GameState gameState) {
    if (gameState.phase == GamePhase.tooFast) {
      // 너무 빨랐을 때 다시 시작
      ref.read(gameStateProvider.notifier).reset();
      return;
    }

    ref.read(gameStateProvider.notifier).onTap();
  }

  void _handleRetry() {
    ref.read(gameStateProvider.notifier).reset();
  }

  void _handleShare(int reactionTime, GradeInfo gradeInfo) {
    ShareService().shareResult(
      reactionTimeMs: reactionTime,
      grade: gradeInfo.name,
      gradeEmoji: gradeInfo.emoji,
    );
  }

  String _getModeTitle(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return '클래식 모드';
      case GameMode.random:
        return '랜덤 모드';
      case GameMode.continuous:
        return '연속 모드';
    }
  }
}
