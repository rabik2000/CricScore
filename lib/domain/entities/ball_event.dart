import 'package:freezed_annotation/freezed_annotation.dart';

part 'ball_event.freezed.dart';
part 'ball_event.g.dart';

@freezed
class BallEvent with _$BallEvent {
  const factory BallEvent({
    required String id,
    required String matchId,
    required String inningsId,
    required int overNumber,
    required int ballNumber,
    required String strikerId,
    required String nonStrikerId,
    required String bowlerId,
    required int runs,
    String? extraType, // 'wide', 'no_ball', 'bye', 'leg_bye'
    required int extraRuns,
    required int runsFromBat,
    required int totalRuns,
    required bool wicket,
    String? dismissalType, // 'bowled', 'caught', 'run_out', etc.
    required bool legalDelivery,
    String? dismissedPlayerId, // To track run-outs
    required DateTime timestamp,
    @Default(false) bool isCorrected,
  }) = _BallEvent;

  factory BallEvent.fromJson(Map<String, dynamic> json) => _$BallEventFromJson(json);
}
