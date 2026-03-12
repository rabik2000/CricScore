// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoringStateImpl _$$ScoringStateImplFromJson(Map<String, dynamic> json) =>
    _$ScoringStateImpl(
      matchId: json['matchId'] as String,
      inningsId: json['inningsId'] as String,
      teamAName: json['teamAName'] as String,
      teamBName: json['teamBName'] as String,
      strikerId: json['strikerId'] as String,
      nonStrikerId: json['nonStrikerId'] as String,
      strikerRuns: (json['strikerRuns'] as num?)?.toInt() ?? 0,
      strikerBalls: (json['strikerBalls'] as num?)?.toInt() ?? 0,
      nonStrikerRuns: (json['nonStrikerRuns'] as num?)?.toInt() ?? 0,
      nonStrikerBalls: (json['nonStrikerBalls'] as num?)?.toInt() ?? 0,
      bowlerId: json['bowlerId'] as String,
      lastBowlerId: json['lastBowlerId'] as String? ?? '',
      totalRuns: (json['totalRuns'] as num).toInt(),
      totalWickets: (json['totalWickets'] as num).toInt(),
      legalBallsThisOver: (json['legalBallsThisOver'] as num).toInt(),
      totalLegalBalls: (json['totalLegalBalls'] as num).toInt(),
      currentOverBalls: (json['currentOverBalls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      previousBowlers: (json['previousBowlers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isTeamABatting: json['isTeamABatting'] as bool? ?? true,
      bowlerLegalBalls:
          (json['bowlerLegalBalls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      bowlerDotBalls:
          (json['bowlerDotBalls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      bowlerWickets:
          (json['bowlerWickets'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      bowlerRuns:
          (json['bowlerRuns'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      isFirstInnings: json['isFirstInnings'] as bool? ?? true,
      targetRuns: (json['targetRuns'] as num?)?.toInt(),
      isMatchComplete: json['isMatchComplete'] as bool? ?? false,
      winnerName: json['winnerName'] as String?,
      lastBallId: json['lastBallId'] as String?,
      lastBallWicket: json['lastBallWicket'] as bool? ?? false,
      isLastManMode: json['isLastManMode'] as bool? ?? false,
      canEnableLastMan: json['canEnableLastMan'] as bool? ?? false,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => ScoringState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScoringStateImplToJson(_$ScoringStateImpl instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'inningsId': instance.inningsId,
      'teamAName': instance.teamAName,
      'teamBName': instance.teamBName,
      'strikerId': instance.strikerId,
      'nonStrikerId': instance.nonStrikerId,
      'strikerRuns': instance.strikerRuns,
      'strikerBalls': instance.strikerBalls,
      'nonStrikerRuns': instance.nonStrikerRuns,
      'nonStrikerBalls': instance.nonStrikerBalls,
      'bowlerId': instance.bowlerId,
      'lastBowlerId': instance.lastBowlerId,
      'totalRuns': instance.totalRuns,
      'totalWickets': instance.totalWickets,
      'legalBallsThisOver': instance.legalBallsThisOver,
      'totalLegalBalls': instance.totalLegalBalls,
      'currentOverBalls': instance.currentOverBalls,
      'previousBowlers': instance.previousBowlers,
      'isTeamABatting': instance.isTeamABatting,
      'bowlerLegalBalls': instance.bowlerLegalBalls,
      'bowlerDotBalls': instance.bowlerDotBalls,
      'bowlerWickets': instance.bowlerWickets,
      'bowlerRuns': instance.bowlerRuns,
      'isFirstInnings': instance.isFirstInnings,
      'targetRuns': instance.targetRuns,
      'isMatchComplete': instance.isMatchComplete,
      'winnerName': instance.winnerName,
      'lastBallId': instance.lastBallId,
      'lastBallWicket': instance.lastBallWicket,
      'isLastManMode': instance.isLastManMode,
      'canEnableLastMan': instance.canEnableLastMan,
      'history': instance.history,
    };
