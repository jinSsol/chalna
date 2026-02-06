import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/game_repository.dart';

/// 연속 모드 결과 카드 위젯 - 미니멀 모던 스타일
class ContinuousResultCard extends StatelessWidget {
  final List<int> results;
  final int averageTime;
  final int bestTime;
  final int worstTime;
  final GradeInfo gradeInfo;
  final bool isNewBestRecord;
  final VoidCallback onRetry;
  final VoidCallback onShare;

  const ContinuousResultCard({
    super.key,
    required this.results,
    required this.averageTime,
    required this.bestTime,
    required this.worstTime,
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
          SvgPicture.asset(
            _getGradeIconPath(),
            width: 56,
            height: 56,
          )
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 20),
          // 평균 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$averageTime',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: gradeColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 64,
                      height: 1,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 4),
                child: Text(
                  'ms',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            '평균',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 24),
          // 라운드별 결과
          _buildRoundResults(context),
          const SizedBox(height: 24),
          // 최고/최저
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip(context, '최고', bestTime, AppColors.success),
              const SizedBox(width: 16),
              _buildStatChip(context, '최저', worstTime, AppColors.textTertiary),
            ],
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
          const SizedBox(height: 40),
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

  Widget _buildRoundResults(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: results.asMap().entries.map((entry) {
        final index = entry.key;
        final time = entry.value;
        final isBest = time == bestTime;
        final isWorst = time == worstTime;

        Color bgColor;
        Color textColor;
        if (isBest) {
          bgColor = AppColors.success.withValues(alpha: 0.1);
          textColor = AppColors.success;
        } else if (isWorst) {
          bgColor = AppColors.textTertiary.withValues(alpha: 0.1);
          textColor = AppColors.textTertiary;
        } else {
          bgColor = AppColors.surfaceLight;
          textColor = AppColors.textSecondary;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                'R${index + 1}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
              ),
              Text(
                '${time}ms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (200 + 50 * index).ms, duration: 200.ms);
      }).toList(),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value}ms',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ],
      ),
    );
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
