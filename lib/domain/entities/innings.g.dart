// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'innings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InningsImpl _$$InningsImplFromJson(Map<String, dynamic> json) =>
    _$InningsImpl(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      battingTeamId: json['battingTeamId'] as String,
      bowlingTeamId: json['bowlingTeamId'] as String,
      runs: (json['runs'] as num).toInt(),
      wickets: (json['wickets'] as num).toInt(),
      overs: (json['overs'] as num).toInt(),
      balls: (json['balls'] as num).toInt(),
      isComplete: json['isComplete'] as bool,
    );

Map<String, dynamic> _$$InningsImplToJson(_$InningsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'battingTeamId': instance.battingTeamId,
      'bowlingTeamId': instance.bowlingTeamId,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'overs': instance.overs,
      'balls': instance.balls,
      'isComplete': instance.isComplete,
    };
