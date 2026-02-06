import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../game/domain/game_mode.dart';
import '../../../game/presentation/providers/game_provider.dart';
import '../../../records/presentation/providers/records_provider.dart';

/// 홈 화면 - 글래스모피즘 UI
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(selectedGameModeProvider);
    final bestRecord = ref.watch(bestRecordProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                _buildStartButton(context, isDark),
                const SizedBox(height: 24),
                _buildBestRecord(context, bestRecord),
                const SizedBox(height: 20),
                _buildModeSelector(context, ref, selectedMode, isDark),
                const SizedBox(height: 12),
                _buildModeDescription(context, selectedMode),
                const Spacer(flex: 2),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/game'),
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accent],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 56,
                color: Colors.white.withValues(alpha: 0.95),
              ),
              const SizedBox(height: 6),
              Text(
                'TAP',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
              ),
            ],
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.03, 1.03),
            duration: 2000.ms,
            curve: Curves.easeInOut,
          ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildBestRecord(BuildContext context, int? bestRecord) {
    if (bestRecord == null) {
      return Text(
        '첫 기록에 도전하세요',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textTertiary,
            ),
      ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
    }

    final gradeInfo = _getGradeInfo(bestRecord);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          gradeInfo.iconPath,
          width: 28,
          height: 28,
        ),
        const SizedBox(width: 12),
        Text(
          '${bestRecord}ms',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: gradeInfo.color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildModeSelector(
      BuildContext context, WidgetRef ref, GameMode selectedMode, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: GameMode.values.map((mode) {
              final isSelected = mode == selectedMode;
              return GestureDetector(
                onTap: () {
                  ref.read(selectedGameModeProvider.notifier).state = mode;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getModeName(mode),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildModeDescription(BuildContext context, GameMode selectedMode) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(
        _getModeDescription(selectedMode),
        key: ValueKey(selectedMode),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
      ),
    );
  }

  String _getModeDescription(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return '화면이 초록색으로 바뀌면 최대한 빨리 탭하세요';
      case GameMode.random:
        return '대기 시간이 1~5초로 랜덤하게 변합니다';
      case GameMode.continuous:
        return '5회 연속 측정 후 평균 반응속도를 확인합니다';
    }
  }

  String _getModeName(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return '클래식';
      case GameMode.random:
        return '랜덤';
      case GameMode.continuous:
        return '연속';
    }
  }

  ({String iconPath, Color color, String name}) _getGradeInfo(int ms) {
    if (ms < 150) {
      return (
        iconPath: 'assets/icons/lightning.svg',
        color: AppColors.gradeLightning,
        name: AppStrings.gradeLightning,
      );
    }
    if (ms < 200) {
      return (
        iconPath: 'assets/icons/rocket.svg',
        color: AppColors.gradeVeryFast,
        name: AppStrings.gradeVeryFast,
      );
    }
    if (ms < 250) {
      return (
        iconPath: 'assets/icons/runner.svg',
        color: AppColors.gradeFast,
        name: AppStrings.gradeFast,
      );
    }
    if (ms < 300) {
      return (
        iconPath: 'assets/icons/walker.svg',
        color: AppColors.gradeNormal,
        name: AppStrings.gradeNormal,
      );
    }
    return (
      iconPath: 'assets/icons/turtle.svg',
      color: AppColors.gradeSlow,
      name: AppStrings.gradeSlow,
    );
  }
}
