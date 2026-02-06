import 'dart:math';
import '../../../core/constants/app_config.dart';

/// 게임 데이터 레포지토리
class GameRepository {
  final Random _random = Random();

  /// 랜덤 대기 시간 생성 (ms)
  int generateWaitTime() {
    return AppConfig.minWaitTime +
        _random.nextInt(AppConfig.maxWaitTime - AppConfig.minWaitTime);
  }

  /// 등급 정보 반환
  GradeInfo getGradeInfo(int reactionTimeMs) {
    if (reactionTimeMs < AppConfig.gradeLightningThreshold) {
      return GradeInfo(
        name: '번개',
        emoji: '⚡',
        description: '프로게이머급',
      );
    } else if (reactionTimeMs < AppConfig.gradeVeryFastThreshold) {
      return GradeInfo(
        name: '매우 빠름',
        emoji: '🚀',
        description: '상위 10%',
      );
    } else if (reactionTimeMs < AppConfig.gradeFastThreshold) {
      return GradeInfo(
        name: '빠름',
        emoji: '🏃',
        description: '평균 이상',
      );
    } else if (reactionTimeMs < AppConfig.gradeNormalThreshold) {
      return GradeInfo(
        name: '보통',
        emoji: '🚶',
        description: '평균',
      );
    } else {
      return GradeInfo(
        name: '느림',
        emoji: '🐢',
        description: '연습 필요',
      );
    }
  }
}

/// 등급 정보
class GradeInfo {
  final String name;
  final String emoji;
  final String description;

  GradeInfo({
    required this.name,
    required this.emoji,
    required this.description,
  });
}
