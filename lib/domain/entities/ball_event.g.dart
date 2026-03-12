// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BallEventImpl _$$BallEventImplFromJson(Map<String, dynamic> json) =>
    _$BallEventImpl(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      inningsId: json['inningsId'] as String,
      overNumber: (json['overNumber'] as num).toInt(),
      ballNumber: (json['ballNumber'] as num).toInt(),
      strikerId: json['strikerId'] as String,
      nonStrikerId: json['nonStrikerId'] as String,
      bowlerId: json['bowlerId'] as String,
      runs: (json['runs'] as num).toInt(),
      extraType: json['extraType'] as String?,
      extraRuns: (json['extraRuns'] as num).toInt(),
      runsFromBat: (json['runsFromBat'] as num).toInt(),
      totalRuns: (json['totalRuns'] as num).toInt(),
      wicket: json['wicket'] as bool,
      dismissalType: json['dismissalType'] as String?,
      legalDelivery: json['legalDelivery'] as bool,
      dismissedPlayerId: json['dismissedPlayerId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isCorrected: json['isCorrected'] as bool? ?? false,
    );

Map<String, dynamic> _$$BallEventImplToJson(_$BallEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'inningsId': instance.inningsId,
      'overNumber': instance.overNumber,
      'ballNumber': instance.ballNumber,
      'strikerId': instance.strikerId,
      'nonStrikerId': instance.nonStrikerId,
      'bowlerId': instance.bowlerId,
      'runs': instance.runs,
      'extraType': instance.extraType,
      'extraRuns': instance.extraRuns,
      'runsFromBat': instance.runsFromBat,
      'totalRuns': instance.totalRuns,
      'wicket': instance.wicket,
      'dismissalType': instance.dismissalType,
      'legalDelivery': instance.legalDelivery,
      'dismissedPlayerId': instance.dismissedPlayerId,
      'timestamp': instance.timestamp.toIso8601String(),
      'isCorrected': instance.isCorrected,
    };
