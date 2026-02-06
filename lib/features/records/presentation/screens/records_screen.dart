import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/ad_banner_widget.dart';
import '../../domain/record_model.dart';
import '../providers/records_provider.dart';

/// 기록 화면 - 글래스모피즘 스타일
class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsState = ref.watch(recordsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  Text(
                    '기록',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recordsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(context, recordsState, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RecordsState recordsState, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBestRecordCard(context, recordsState, isDark),
          const SizedBox(height: 16),
          _buildStatsCard(context, recordsState, isDark),
          const SizedBox(height: 24),
          _buildRecentRecords(context, recordsState, isDark),
          const SizedBox(height: 24),
          const AdBannerWidget(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({
    required BuildContext context,
    required bool isDark,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 24,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBestRecordCard(BuildContext context, RecordsState recordsState, bool isDark) {
    final bestRecord = recordsState.bestRecord;
    final gradeInfo = bestRecord != null ? _getGradeInfo(bestRecord) : null;

    return _buildGlassContainer(
      context: context,
      isDark: isDark,
      child: Column(
        children: [
          if (bestRecord != null) ...[
            SvgPicture.asset(
              gradeInfo!.iconPath,
              width: 56,
              height: 56,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$bestRecord',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: gradeInfo.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 56,
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
            ),
            const SizedBox(height: 6),
            Text(
              gradeInfo.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: gradeInfo.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ] else ...[
            Icon(
              Icons.emoji_events_outlined,
              size: 56,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              '기록 없음',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatsCard(BuildContext context, RecordsState recordsState, bool isDark) {
    return _buildGlassContainer(
      context: context,
      isDark: isDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              label: '평균',
              value: recordsState.averageRecord != null
                  ? '${recordsState.averageRecord}ms'
                  : '-',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              label: '총 게임',
              value: '${recordsState.totalPlayCount}회',
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildRecentRecords(BuildContext context, RecordsState recordsState, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 기록',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 12),
        if (recordsState.recentRecords.isEmpty)
          _buildEmptyRecords(context, isDark)
        else
          _buildRecordsList(context, recordsState.recentRecords, isDark),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildEmptyRecords(BuildContext context, bool isDark) {
    return _buildGlassContainer(
      context: context,
      isDark: isDark,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.sports_esports_outlined,
            size: 36,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            '아직 기록이 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context, List<RecordModel> records, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = records[index];
        final gradeInfo = _getGradeInfo(record.reactionTimeMs);
        final timeAgo = _getTimeAgo(record.createdAt);

        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    gradeInfo.iconPath,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${record.reactionTimeMs}ms',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: gradeInfo.color,
                              ),
                        ),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildModeChip(context, record.gameModeIndex, isDark),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: (50 * index).ms, duration: 300.ms);
      },
    );
  }

  Widget _buildModeChip(BuildContext context, int modeIndex, bool isDark) {
    final modeName = switch (modeIndex) {
      0 => '클래식',
      1 => '랜덤',
      2 => '연속',
      _ => '?',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        modeName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  ({String iconPath, Color color, String name}) _getGradeInfo(int ms) {
    if (ms < AppConfig.gradeLightningThreshold) {
      return (
        iconPath: 'assets/icons/lightning.svg',
        color: AppColors.gradeLightning,
        name: AppStrings.gradeLightning,
      );
    }
    if (ms < AppConfig.gradeVeryFastThreshold) {
      return (
        iconPath: 'assets/icons/rocket.svg',
        color: AppColors.gradeVeryFast,
        name: AppStrings.gradeVeryFast,
      );
    }
    if (ms < AppConfig.gradeFastThreshold) {
      return (
        iconPath: 'assets/icons/runner.svg',
        color: AppColors.gradeFast,
        name: AppStrings.gradeFast,
      );
    }
    if (ms < AppConfig.gradeNormalThreshold) {
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return AppStrings.justNow;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }
}
