// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
  id: json['id'] as String,
  teamAId: json['teamAId'] as String,
  teamBId: json['teamBId'] as String,
  oversLimit: (json['oversLimit'] as num).toInt(),
  tossWinnerId: json['tossWinnerId'] as String?,
  tossDecision: json['tossDecision'] as String?,
  status: $enumDecode(_$MatchStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamAId': instance.teamAId,
      'teamBId': instance.teamBId,
      'oversLimit': instance.oversLimit,
      'tossWinnerId': instance.tossWinnerId,
      'tossDecision': instance.tossDecision,
      'status': _$MatchStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$MatchStatusEnumMap = {
  MatchStatus.scheduled: 'scheduled',
  MatchStatus.live: 'live',
  MatchStatus.completed: 'completed',
};
