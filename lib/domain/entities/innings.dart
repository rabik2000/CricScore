import 'package:freezed_annotation/freezed_annotation.dart';

part 'innings.freezed.dart';
part 'innings.g.dart';

@freezed
class Innings with _$Innings {
  const factory Innings({
    required String id,
    required String matchId,
    required String battingTeamId,
    required String bowlingTeamId,
    required int runs,
    required int wickets,
    required int overs,
    required int balls,
    required bool isComplete,
  }) = _Innings;

  factory Innings.fromJson(Map<String, dynamic> json) => _$InningsFromJson(json);
}
