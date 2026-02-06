import 'package:hive/hive.dart';
import '../../game/domain/game_mode.dart';

part 'record_model.g.dart';

/// 기록 모델
@HiveType(typeId: 0)
class RecordModel extends HiveObject {
  @HiveField(0)
  final int reactionTimeMs;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final int gameModeIndex;

  RecordModel({
    required this.reactionTimeMs,
    required this.createdAt,
    required this.gameModeIndex,
  });

  GameMode get gameMode => GameMode.values[gameModeIndex];

  factory RecordModel.create({
    required int reactionTimeMs,
    required GameMode gameMode,
  }) {
    return RecordModel(
      reactionTimeMs: reactionTimeMs,
      createdAt: DateTime.now(),
      gameModeIndex: gameMode.index,
    );
  }
}
