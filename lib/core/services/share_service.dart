import 'package:share_plus/share_plus.dart';
import '../constants/app_strings.dart';

/// 공유 서비스
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  /// 결과 공유
  Future<void> shareResult({
    required int reactionTimeMs,
    required String grade,
    required String gradeEmoji,
  }) async {
    final text = '''
${AppStrings.shareTitle}
내 반응속도: ${reactionTimeMs}ms ($gradeEmoji $grade)
너는 얼마나 빠를까?
''';

    await Share.share(text);
  }
}
