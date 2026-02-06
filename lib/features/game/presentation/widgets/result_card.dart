import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/game_repository.dart';

/// 결과 카드 위젯 - 미니멀 모던 스타일
class ResultCard extends StatelessWidget {
  final int reactionTimeMs;
  final GradeInfo gradeInfo;
  final bool isNewBestRecord;
  final VoidCallback onRetry;
  final VoidCallback onShare;

  const ResultCard({
    super.key,
    required this.reactionTimeMs,
    required this.gradeInfo,
    required this.isNewBestRecord,
    required this.onRetry,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 등급 아이콘
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gradeColor.withValues(alpha: 0.1),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getGradeIconPath(),
                width: 56,
                height: 56,
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 24),
          // 등급 이름
          Text(
            gradeInfo.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: gradeColor,
                  fontWeight: FontWeight.w800,
                ),
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 300.ms),
          const SizedBox(height: 32),
          // 반응 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$reactionTimeMs',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 72,
                      height: 1,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 4),
                child: Text(
                  AppStrings.ms,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 300.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          // 등급 설명
          Text(
            gradeInfo.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ).animate().fadeIn(delay: 350.ms, duration: 300.ms),
          // 새로운 최고 기록 표시
          if (isNewBestRecord) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.newBestRecord,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 450.ms, duration: 300.ms)
                .shake(hz: 2, duration: 400.ms),
          ],
          const SizedBox(height: 48),
          // 버튼들
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  context,
                  onPressed: onRetry,
                  icon: Icons.replay_rounded,
                  label: AppStrings.retry,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildButton(
                  context,
                  onPressed: onShare,
                  icon: Icons.share_rounded,
                  label: AppStrings.share,
                  isPrimary: true,
                  color: gradeColor,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 500.ms, duration: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
    Color? color,
  }) {
    if (isPrimary) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor() {
    switch (gradeInfo.name) {
      case '번개':
        return AppColors.gradeLightning;
      case '매우 빠름':
        return AppColors.gradeVeryFast;
      case '빠름':
        return AppColors.gradeFast;
      case '보통':
        return AppColors.gradeNormal;
      case '느림':
      default:
        return AppColors.gradeSlow;
    }
  }

  String _getGradeIconPath() {
    switch (gradeInfo.name) {
      case '번개':
        return 'assets/icons/lightning.svg';
      case '매우 빠름':
        return 'assets/icons/rocket.svg';
      case '빠름':
        return 'assets/icons/runner.svg';
      case '보통':
        return 'assets/icons/walker.svg';
      case '느림':
      default:
        return 'assets/icons/turtle.svg';
    }
  }
}
