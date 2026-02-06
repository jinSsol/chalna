import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_config.dart';
import '../../game/domain/game_mode.dart';
import '../domain/record_model.dart';

/// 기록 레포지토리
class RecordsRepository {
  static const String _boxName = AppConfig.recordsBox;
  Box<RecordModel>? _box;

  /// 초기화
  Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecordModelAdapter());
    }
    _box = await Hive.openBox<RecordModel>(_boxName);
  }

  /// 기록 추가
  Future<void> addRecord(RecordModel record) async {
    await _box?.add(record);
  }

  /// 모든 기록 조회
  List<RecordModel> getAllRecords() {
    if (_box == null) return [];
    return _box!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 모드별 기록 조회
  List<RecordModel> getRecordsByMode(GameMode mode) {
    return getAllRecords()
        .where((record) => record.gameMode == mode)
        .toList();
  }

  /// 최근 N개 기록 조회
  List<RecordModel> getRecentRecords({int limit = AppConfig.maxRecentRecords}) {
    final records = getAllRecords();
    return records.take(limit).toList();
  }

  /// 최고 기록 조회 (전체)
  int? getBestRecord() {
    final records = getAllRecords();
    if (records.isEmpty) return null;
    return records
        .map((r) => r.reactionTimeMs)
        .reduce((a, b) => a < b ? a : b);
  }

  /// 모드별 최고 기록 조회
  int? getBestRecordByMode(GameMode mode) {
    final records = getRecordsByMode(mode);
    if (records.isEmpty) return null;
    return records
        .map((r) => r.reactionTimeMs)
        .reduce((a, b) => a < b ? a : b);
  }

  /// 평균 기록 조회
  int? getAverageRecord() {
    final records = getAllRecords();
    if (records.isEmpty) return null;
    final sum = records.map((r) => r.reactionTimeMs).reduce((a, b) => a + b);
    return (sum / records.length).round();
  }

  /// 총 플레이 횟수
  int getTotalPlayCount() {
    return _box?.length ?? 0;
  }

  /// 모든 기록 삭제
  Future<void> clearAllRecords() async {
    await _box?.clear();
  }

  /// 박스 닫기
  Future<void> close() async {
    await _box?.close();
  }
}
