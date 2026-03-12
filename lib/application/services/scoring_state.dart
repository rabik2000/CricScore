import 'package:freezed_annotation/freezed_annotation.dart';

part 'scoring_state.freezed.dart';
part 'scoring_state.g.dart';

@freezed
class ScoringState with _$ScoringState {
  const factory ScoringState({
    required String matchId,
    required String inningsId,
    required String teamAName,
    required String teamBName,
    required String strikerId, // Used as Name
    required String nonStrikerId, // Used as Name
    @Default(0) int strikerRuns,
    @Default(0) int strikerBalls,
    @Default(0) int nonStrikerRuns,
    @Default(0) int nonStrikerBalls,
    required String bowlerId,
    @Default('') String lastBowlerId,
    required int totalRuns,
    required int totalWickets,
    required int legalBallsThisOver,
    required int totalLegalBalls,
    required List<String> currentOverBalls,
    required List<String> previousBowlers,
    @Default(true) bool isTeamABatting,
    @Default({}) Map<String, int> bowlerLegalBalls,
    @Default({}) Map<String, int> bowlerDotBalls,
    @Default({}) Map<String, int> bowlerWickets,
    @Default({}) Map<String, int> bowlerRuns,
    @Default(true) bool isFirstInnings,
    int? targetRuns,
    @Default(false) bool isMatchComplete,
    String? winnerName,
    String? lastBallId,
    @Default(false) bool lastBallWicket,
    @Default(false) bool isLastManMode,
    @Default(false) bool canEnableLastMan,
    @Default([]) List<ScoringState> history,
  }) = _ScoringState;

  factory ScoringState.fromJson(Map<String, dynamic> json) => _$ScoringStateFromJson(json);
}
