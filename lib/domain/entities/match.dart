import 'package:freezed_annotation/freezed_annotation.dart';

part 'match.freezed.dart';
part 'match.g.dart';

enum MatchStatus { scheduled, live, completed }

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String teamAId,
    required String teamBId,
    required int oversLimit,
    String? tossWinnerId,
    String? tossDecision, // 'bat' or 'bowl'
    required MatchStatus status,
    required DateTime createdAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
