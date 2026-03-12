// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BallEvent _$BallEventFromJson(Map<String, dynamic> json) {
  return _BallEvent.fromJson(json);
}

/// @nodoc
mixin _$BallEvent {
  String get id => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get inningsId => throw _privateConstructorUsedError;
  int get overNumber => throw _privateConstructorUsedError;
  int get ballNumber => throw _privateConstructorUsedError;
  String get strikerId => throw _privateConstructorUsedError;
  String get nonStrikerId => throw _privateConstructorUsedError;
  String get bowlerId => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  String? get extraType =>
      throw _privateConstructorUsedError; // 'wide', 'no_ball', 'bye', 'leg_bye'
  int get extraRuns => throw _privateConstructorUsedError;
  int get runsFromBat => throw _privateConstructorUsedError;
  int get totalRuns => throw _privateConstructorUsedError;
  bool get wicket => throw _privateConstructorUsedError;
  String? get dismissalType =>
      throw _privateConstructorUsedError; // 'bowled', 'caught', 'run_out', etc.
  bool get legalDelivery => throw _privateConstructorUsedError;
  String? get dismissedPlayerId =>
      throw _privateConstructorUsedError; // To track run-outs
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isCorrected => throw _privateConstructorUsedError;

  /// Serializes this BallEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BallEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallEventCopyWith<BallEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallEventCopyWith<$Res> {
  factory $BallEventCopyWith(BallEvent value, $Res Function(BallEvent) then) =
      _$BallEventCopyWithImpl<$Res, BallEvent>;
  @useResult
  $Res call({
    String id,
    String matchId,
    String inningsId,
    int overNumber,
    int ballNumber,
    String strikerId,
    String nonStrikerId,
    String bowlerId,
    int runs,
    String? extraType,
    int extraRuns,
    int runsFromBat,
    int totalRuns,
    bool wicket,
    String? dismissalType,
    bool legalDelivery,
    String? dismissedPlayerId,
    DateTime timestamp,
    bool isCorrected,
  });
}

/// @nodoc
class _$BallEventCopyWithImpl<$Res, $Val extends BallEvent>
    implements $BallEventCopyWith<$Res> {
  _$BallEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? inningsId = null,
    Object? overNumber = null,
    Object? ballNumber = null,
    Object? strikerId = null,
    Object? nonStrikerId = null,
    Object? bowlerId = null,
    Object? runs = null,
    Object? extraType = freezed,
    Object? extraRuns = null,
    Object? runsFromBat = null,
    Object? totalRuns = null,
    Object? wicket = null,
    Object? dismissalType = freezed,
    Object? legalDelivery = null,
    Object? dismissedPlayerId = freezed,
    Object? timestamp = null,
    Object? isCorrected = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            inningsId: null == inningsId
                ? _value.inningsId
                : inningsId // ignore: cast_nullable_to_non_nullable
                      as String,
            overNumber: null == overNumber
                ? _value.overNumber
                : overNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            ballNumber: null == ballNumber
                ? _value.ballNumber
                : ballNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            strikerId: null == strikerId
                ? _value.strikerId
                : strikerId // ignore: cast_nullable_to_non_nullable
                      as String,
            nonStrikerId: null == nonStrikerId
                ? _value.nonStrikerId
                : nonStrikerId // ignore: cast_nullable_to_non_nullable
                      as String,
            bowlerId: null == bowlerId
                ? _value.bowlerId
                : bowlerId // ignore: cast_nullable_to_non_nullable
                      as String,
            runs: null == runs
                ? _value.runs
                : runs // ignore: cast_nullable_to_non_nullable
                      as int,
            extraType: freezed == extraType
                ? _value.extraType
                : extraType // ignore: cast_nullable_to_non_nullable
                      as String?,
            extraRuns: null == extraRuns
                ? _value.extraRuns
                : extraRuns // ignore: cast_nullable_to_non_nullable
                      as int,
            runsFromBat: null == runsFromBat
                ? _value.runsFromBat
                : runsFromBat // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRuns: null == totalRuns
                ? _value.totalRuns
                : totalRuns // ignore: cast_nullable_to_non_nullable
                      as int,
            wicket: null == wicket
                ? _value.wicket
                : wicket // ignore: cast_nullable_to_non_nullable
                      as bool,
            dismissalType: freezed == dismissalType
                ? _value.dismissalType
                : dismissalType // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalDelivery: null == legalDelivery
                ? _value.legalDelivery
                : legalDelivery // ignore: cast_nullable_to_non_nullable
                      as bool,
            dismissedPlayerId: freezed == dismissedPlayerId
                ? _value.dismissedPlayerId
                : dismissedPlayerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isCorrected: null == isCorrected
                ? _value.isCorrected
                : isCorrected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BallEventImplCopyWith<$Res>
    implements $BallEventCopyWith<$Res> {
  factory _$$BallEventImplCopyWith(
    _$BallEventImpl value,
    $Res Function(_$BallEventImpl) then,
  ) = __$$BallEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String matchId,
    String inningsId,
    int overNumber,
    int ballNumber,
    String strikerId,
    String nonStrikerId,
    String bowlerId,
    int runs,
    String? extraType,
    int extraRuns,
    int runsFromBat,
    int totalRuns,
    bool wicket,
    String? dismissalType,
    bool legalDelivery,
    String? dismissedPlayerId,
    DateTime timestamp,
    bool isCorrected,
  });
}

/// @nodoc
class __$$BallEventImplCopyWithImpl<$Res>
    extends _$BallEventCopyWithImpl<$Res, _$BallEventImpl>
    implements _$$BallEventImplCopyWith<$Res> {
  __$$BallEventImplCopyWithImpl(
    _$BallEventImpl _value,
    $Res Function(_$BallEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BallEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? inningsId = null,
    Object? overNumber = null,
    Object? ballNumber = null,
    Object? strikerId = null,
    Object? nonStrikerId = null,
    Object? bowlerId = null,
    Object? runs = null,
    Object? extraType = freezed,
    Object? extraRuns = null,
    Object? runsFromBat = null,
    Object? totalRuns = null,
    Object? wicket = null,
    Object? dismissalType = freezed,
    Object? legalDelivery = null,
    Object? dismissedPlayerId = freezed,
    Object? timestamp = null,
    Object? isCorrected = null,
  }) {
    return _then(
      _$BallEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        inningsId: null == inningsId
            ? _value.inningsId
            : inningsId // ignore: cast_nullable_to_non_nullable
                  as String,
        overNumber: null == overNumber
            ? _value.overNumber
            : overNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        ballNumber: null == ballNumber
            ? _value.ballNumber
            : ballNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        strikerId: null == strikerId
            ? _value.strikerId
            : strikerId // ignore: cast_nullable_to_non_nullable
                  as String,
        nonStrikerId: null == nonStrikerId
            ? _value.nonStrikerId
            : nonStrikerId // ignore: cast_nullable_to_non_nullable
                  as String,
        bowlerId: null == bowlerId
            ? _value.bowlerId
            : bowlerId // ignore: cast_nullable_to_non_nullable
                  as String,
        runs: null == runs
            ? _value.runs
            : runs // ignore: cast_nullable_to_non_nullable
                  as int,
        extraType: freezed == extraType
            ? _value.extraType
            : extraType // ignore: cast_nullable_to_non_nullable
                  as String?,
        extraRuns: null == extraRuns
            ? _value.extraRuns
            : extraRuns // ignore: cast_nullable_to_non_nullable
                  as int,
        runsFromBat: null == runsFromBat
            ? _value.runsFromBat
            : runsFromBat // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRuns: null == totalRuns
            ? _value.totalRuns
            : totalRuns // ignore: cast_nullable_to_non_nullable
                  as int,
        wicket: null == wicket
            ? _value.wicket
            : wicket // ignore: cast_nullable_to_non_nullable
                  as bool,
        dismissalType: freezed == dismissalType
            ? _value.dismissalType
            : dismissalType // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalDelivery: null == legalDelivery
            ? _value.legalDelivery
            : legalDelivery // ignore: cast_nullable_to_non_nullable
                  as bool,
        dismissedPlayerId: freezed == dismissedPlayerId
            ? _value.dismissedPlayerId
            : dismissedPlayerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isCorrected: null == isCorrected
            ? _value.isCorrected
            : isCorrected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BallEventImpl implements _BallEvent {
  const _$BallEventImpl({
    required this.id,
    required this.matchId,
    required this.inningsId,
    required this.overNumber,
    required this.ballNumber,
    required this.strikerId,
    required this.nonStrikerId,
    required this.bowlerId,
    required this.runs,
    this.extraType,
    required this.extraRuns,
    required this.runsFromBat,
    required this.totalRuns,
    required this.wicket,
    this.dismissalType,
    required this.legalDelivery,
    this.dismissedPlayerId,
    required this.timestamp,
    this.isCorrected = false,
  });

  factory _$BallEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$BallEventImplFromJson(json);

  @override
  final String id;
  @override
  final String matchId;
  @override
  final String inningsId;
  @override
  final int overNumber;
  @override
  final int ballNumber;
  @override
  final String strikerId;
  @override
  final String nonStrikerId;
  @override
  final String bowlerId;
  @override
  final int runs;
  @override
  final String? extraType;
  // 'wide', 'no_ball', 'bye', 'leg_bye'
  @override
  final int extraRuns;
  @override
  final int runsFromBat;
  @override
  final int totalRuns;
  @override
  final bool wicket;
  @override
  final String? dismissalType;
  // 'bowled', 'caught', 'run_out', etc.
  @override
  final bool legalDelivery;
  @override
  final String? dismissedPlayerId;
  // To track run-outs
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isCorrected;

  @override
  String toString() {
    return 'BallEvent(id: $id, matchId: $matchId, inningsId: $inningsId, overNumber: $overNumber, ballNumber: $ballNumber, strikerId: $strikerId, nonStrikerId: $nonStrikerId, bowlerId: $bowlerId, runs: $runs, extraType: $extraType, extraRuns: $extraRuns, runsFromBat: $runsFromBat, totalRuns: $totalRuns, wicket: $wicket, dismissalType: $dismissalType, legalDelivery: $legalDelivery, dismissedPlayerId: $dismissedPlayerId, timestamp: $timestamp, isCorrected: $isCorrected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.inningsId, inningsId) ||
                other.inningsId == inningsId) &&
            (identical(other.overNumber, overNumber) ||
                other.overNumber == overNumber) &&
            (identical(other.ballNumber, ballNumber) ||
                other.ballNumber == ballNumber) &&
            (identical(other.strikerId, strikerId) ||
                other.strikerId == strikerId) &&
            (identical(other.nonStrikerId, nonStrikerId) ||
                other.nonStrikerId == nonStrikerId) &&
            (identical(other.bowlerId, bowlerId) ||
                other.bowlerId == bowlerId) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.extraType, extraType) ||
                other.extraType == extraType) &&
            (identical(other.extraRuns, extraRuns) ||
                other.extraRuns == extraRuns) &&
            (identical(other.runsFromBat, runsFromBat) ||
                other.runsFromBat == runsFromBat) &&
            (identical(other.totalRuns, totalRuns) ||
                other.totalRuns == totalRuns) &&
            (identical(other.wicket, wicket) || other.wicket == wicket) &&
            (identical(other.dismissalType, dismissalType) ||
                other.dismissalType == dismissalType) &&
            (identical(other.legalDelivery, legalDelivery) ||
                other.legalDelivery == legalDelivery) &&
            (identical(other.dismissedPlayerId, dismissedPlayerId) ||
                other.dismissedPlayerId == dismissedPlayerId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isCorrected, isCorrected) ||
                other.isCorrected == isCorrected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    matchId,
    inningsId,
    overNumber,
    ballNumber,
    strikerId,
    nonStrikerId,
    bowlerId,
    runs,
    extraType,
    extraRuns,
    runsFromBat,
    totalRuns,
    wicket,
    dismissalType,
    legalDelivery,
    dismissedPlayerId,
    timestamp,
    isCorrected,
  ]);

  /// Create a copy of BallEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallEventImplCopyWith<_$BallEventImpl> get copyWith =>
      __$$BallEventImplCopyWithImpl<_$BallEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BallEventImplToJson(this);
  }
}

abstract class _BallEvent implements BallEvent {
  const factory _BallEvent({
    required final String id,
    required final String matchId,
    required final String inningsId,
    required final int overNumber,
    required final int ballNumber,
    required final String strikerId,
    required final String nonStrikerId,
    required final String bowlerId,
    required final int runs,
    final String? extraType,
    required final int extraRuns,
    required final int runsFromBat,
    required final int totalRuns,
    required final bool wicket,
    final String? dismissalType,
    required final bool legalDelivery,
    final String? dismissedPlayerId,
    required final DateTime timestamp,
    final bool isCorrected,
  }) = _$BallEventImpl;

  factory _BallEvent.fromJson(Map<String, dynamic> json) =
      _$BallEventImpl.fromJson;

  @override
  String get id;
  @override
  String get matchId;
  @override
  String get inningsId;
  @override
  int get overNumber;
  @override
  int get ballNumber;
  @override
  String get strikerId;
  @override
  String get nonStrikerId;
  @override
  String get bowlerId;
  @override
  int get runs;
  @override
  String? get extraType; // 'wide', 'no_ball', 'bye', 'leg_bye'
  @override
  int get extraRuns;
  @override
  int get runsFromBat;
  @override
  int get totalRuns;
  @override
  bool get wicket;
  @override
  String? get dismissalType; // 'bowled', 'caught', 'run_out', etc.
  @override
  bool get legalDelivery;
  @override
  String? get dismissedPlayerId; // To track run-outs
  @override
  DateTime get timestamp;
  @override
  bool get isCorrected;

  /// Create a copy of BallEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallEventImplCopyWith<_$BallEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
