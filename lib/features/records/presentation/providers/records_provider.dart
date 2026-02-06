import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/records_repository.dart';
import '../../domain/record_model.dart';
import '../../../game/domain/game_mode.dart';

/// 기록 레포지토리 Provider
final recordsRepositoryProvider = Provider<RecordsRepository>((ref) {
  return RecordsRepository();
});

/// 기록 상태 Provider
final recordsProvider =
    StateNotifierProvider<RecordsNotifier, RecordsState>((ref) {
  final repository = ref.watch(recordsRepositoryProvider);
  return RecordsNotifier(repository);
});

/// 최고 기록 Provider (홈 화면용)
final bestRecordProvider = Provider<int?>((ref) {
  final state = ref.watch(recordsProvider);
  return state.bestRecord;
});

/// 기록 상태
class RecordsState {
  final List<RecordModel> recentRecords;
  final int? bestRecord;
  final int? averageRecord;
  final int totalPlayCount;
  final bool isLoading;

  const RecordsState({
    this.recentRecords = const [],
    this.bestRecord,
    this.averageRecord,
    this.totalPlayCount = 0,
    this.isLoading = false,
  });

  RecordsState copyWith({
    List<RecordModel>? recentRecords,
    int? bestRecord,
    int? averageRecord,
    int? totalPlayCount,
    bool? isLoading,
  }) {
    return RecordsState(
      recentRecords: recentRecords ?? this.recentRecords,
      bestRecord: bestRecord ?? this.bestRecord,
      averageRecord: averageRecord ?? this.averageRecord,
      totalPlayCount: totalPlayCount ?? this.totalPlayCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 기록 관리 Notifier
class RecordsNotifier extends StateNotifier<RecordsState> {
  final RecordsRepository _repository;
  bool _isInitialized = false;

  RecordsNotifier(this._repository) : super(const RecordsState());

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    state = state.copyWith(isLoading: true);
    await _repository.initialize();
    _isInitialized = true;
    await _loadRecords();
  }

  /// 기록 로드
  Future<void> _loadRecords() async {
    final recentRecords = _repository.getRecentRecords();
    final bestRecord = _repository.getBestRecord();
    final averageRecord = _repository.getAverageRecord();
    final totalPlayCount = _repository.getTotalPlayCount();

    state = RecordsState(
      recentRecords: recentRecords,
      bestRecord: bestRecord,
      averageRecord: averageRecord,
      totalPlayCount: totalPlayCount,
      isLoading: false,
    );
  }

  /// 기록 추가
  /// 새로운 최고 기록이면 true 반환
  Future<bool> addRecord(int reactionTimeMs, GameMode mode) async {
    if (!_isInitialized) {
      await initialize();
    }

    final currentBest = _repository.getBestRecord();
    final isNewBest = currentBest == null || reactionTimeMs < currentBest;

    final record = RecordModel.create(
      reactionTimeMs: reactionTimeMs,
      gameMode: mode,
    );

    await _repository.addRecord(record);
    await _loadRecords();

    return isNewBest;
  }

  /// 모든 기록 삭제
  Future<void> clearAllRecords() async {
    await _repository.clearAllRecords();
    await _loadRecords();
  }
}
