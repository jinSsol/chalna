import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/game_state.dart';

/// 게임 탭 영역 위젯 - 미니멀 모던 스타일
class TapArea extends StatelessWidget {
  final GamePhase phase;
  final VoidCallback onTap;
  final int? currentRound;
  final int? totalRounds;

  const TapArea({
    super.key,
    required this.phase,
    required this.onTap,
    this.currentRound,
    this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        color: _getBackgroundColor(),
        child: SafeArea(
          child: Center(
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (phase) {
      case GamePhase.idle:
        return AppColors.backgroundLight;
      case GamePhase.ready:
        return AppColors.ready;
      case GamePhase.signal:
        return AppColors.signal;
      case GamePhase.result:
        return AppColors.backgroundLight;
      case GamePhase.tooFast:
        return AppColors.warning;
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (phase) {
      case GamePhase.idle:
        return _buildIdleContent(context);
      case GamePhase.ready:
        return _buildReadyContent(context);
      case GamePhase.signal:
        return _buildSignalContent(context);
      case GamePhase.result:
        return const SizedBox.shrink();
      case GamePhase.tooFast:
        return _buildTooFastContent(context);
    }
  }

  Widget _buildIdleContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentRound != null && totalRounds != null) ...[
          Text(
            '${currentRound! + 1} / $totalRounds',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 60),
        ],
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceLight,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.touch_app_rounded,
            size: 72,
            color: AppColors.primary,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1500.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 48),
        Text(
          AppStrings.tapToStart,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '화면을 터치하세요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildReadyContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.pan_tool_rounded,
          size: 100,
          color: Colors.white.withValues(alpha: 0.9),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(0.9, 0.9),
              duration: 600.ms,
            ),
        const SizedBox(height: 48),
        Text(
          '대기',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          '초록색이 될 때까지 기다리세요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
      ],
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildSignalContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.5),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'GO',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.signal,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 150.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 48),
        Text(
          '지금!',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ).animate().fadeIn(duration: 100.ms),
      ],
    );
  }

  Widget _buildTooFastContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 80,
            color: Colors.white,
          ),
        ).animate().shake(hz: 4, duration: 400.ms),
        const SizedBox(height: 40),
        Text(
          '너무 빨라요!',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          '초록색이 될 때까지 기다리세요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '탭하여 다시 시작',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 800.ms,
            ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
