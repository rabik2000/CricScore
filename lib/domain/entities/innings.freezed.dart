// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'innings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Innings _$InningsFromJson(Map<String, dynamic> json) {
  return _Innings.fromJson(json);
}

/// @nodoc
mixin _$Innings {
  String get id => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get battingTeamId => throw _privateConstructorUsedError;
  String get bowlingTeamId => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  int get wickets => throw _privateConstructorUsedError;
  int get overs => throw _privateConstructorUsedError;
  int get balls => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;

  /// Serializes this Innings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InningsCopyWith<Innings> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InningsCopyWith<$Res> {
  factory $InningsCopyWith(Innings value, $Res Function(Innings) then) =
      _$InningsCopyWithImpl<$Res, Innings>;
  @useResult
  $Res call({
    String id,
    String matchId,
    String battingTeamId,
    String bowlingTeamId,
    int runs,
    int wickets,
    int overs,
    int balls,
    bool isComplete,
  });
}

/// @nodoc
class _$InningsCopyWithImpl<$Res, $Val extends Innings>
    implements $InningsCopyWith<$Res> {
  _$InningsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? battingTeamId = null,
    Object? bowlingTeamId = null,
    Object? runs = null,
    Object? wickets = null,
    Object? overs = null,
    Object? balls = null,
    Object? isComplete = null,
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
            battingTeamId: null == battingTeamId
                ? _value.battingTeamId
                : battingTeamId // ignore: cast_nullable_to_non_nullable
                      as String,
            bowlingTeamId: null == bowlingTeamId
                ? _value.bowlingTeamId
                : bowlingTeamId // ignore: cast_nullable_to_non_nullable
                      as String,
            runs: null == runs
                ? _value.runs
                : runs // ignore: cast_nullable_to_non_nullable
                      as int,
            wickets: null == wickets
                ? _value.wickets
                : wickets // ignore: cast_nullable_to_non_nullable
                      as int,
            overs: null == overs
                ? _value.overs
                : overs // ignore: cast_nullable_to_non_nullable
                      as int,
            balls: null == balls
                ? _value.balls
                : balls // ignore: cast_nullable_to_non_nullable
                      as int,
            isComplete: null == isComplete
                ? _value.isComplete
                : isComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InningsImplCopyWith<$Res> implements $InningsCopyWith<$Res> {
  factory _$$InningsImplCopyWith(
    _$InningsImpl value,
    $Res Function(_$InningsImpl) then,
  ) = __$$InningsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String matchId,
    String battingTeamId,
    String bowlingTeamId,
    int runs,
    int wickets,
    int overs,
    int balls,
    bool isComplete,
  });
}

/// @nodoc
class __$$InningsImplCopyWithImpl<$Res>
    extends _$InningsCopyWithImpl<$Res, _$InningsImpl>
    implements _$$InningsImplCopyWith<$Res> {
  __$$InningsImplCopyWithImpl(
    _$InningsImpl _value,
    $Res Function(_$InningsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? battingTeamId = null,
    Object? bowlingTeamId = null,
    Object? runs = null,
    Object? wickets = null,
    Object? overs = null,
    Object? balls = null,
    Object? isComplete = null,
  }) {
    return _then(
      _$InningsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        battingTeamId: null == battingTeamId
            ? _value.battingTeamId
            : battingTeamId // ignore: cast_nullable_to_non_nullable
                  as String,
        bowlingTeamId: null == bowlingTeamId
            ? _value.bowlingTeamId
            : bowlingTeamId // ignore: cast_nullable_to_non_nullable
                  as String,
        runs: null == runs
            ? _value.runs
            : runs // ignore: cast_nullable_to_non_nullable
                  as int,
        wickets: null == wickets
            ? _value.wickets
            : wickets // ignore: cast_nullable_to_non_nullable
                  as int,
        overs: null == overs
            ? _value.overs
            : overs // ignore: cast_nullable_to_non_nullable
                  as int,
        balls: null == balls
            ? _value.balls
            : balls // ignore: cast_nullable_to_non_nullable
                  as int,
        isComplete: null == isComplete
            ? _value.isComplete
            : isComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InningsImpl implements _Innings {
  const _$InningsImpl({
    required this.id,
    required this.matchId,
    required this.battingTeamId,
    required this.bowlingTeamId,
    required this.runs,
    required this.wickets,
    required this.overs,
    required this.balls,
    required this.isComplete,
  });

  factory _$InningsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InningsImplFromJson(json);

  @override
  final String id;
  @override
  final String matchId;
  @override
  final String battingTeamId;
  @override
  final String bowlingTeamId;
  @override
  final int runs;
  @override
  final int wickets;
  @override
  final int overs;
  @override
  final int balls;
  @override
  final bool isComplete;

  @override
  String toString() {
    return 'Innings(id: $id, matchId: $matchId, battingTeamId: $battingTeamId, bowlingTeamId: $bowlingTeamId, runs: $runs, wickets: $wickets, overs: $overs, balls: $balls, isComplete: $isComplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InningsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.battingTeamId, battingTeamId) ||
                other.battingTeamId == battingTeamId) &&
            (identical(other.bowlingTeamId, bowlingTeamId) ||
                other.bowlingTeamId == bowlingTeamId) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.wickets, wickets) || other.wickets == wickets) &&
            (identical(other.overs, overs) || other.overs == overs) &&
            (identical(other.balls, balls) || other.balls == balls) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    matchId,
    battingTeamId,
    bowlingTeamId,
    runs,
    wickets,
    overs,
    balls,
    isComplete,
  );

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InningsImplCopyWith<_$InningsImpl> get copyWith =>
      __$$InningsImplCopyWithImpl<_$InningsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InningsImplToJson(this);
  }
}

abstract class _Innings implements Innings {
  const factory _Innings({
    required final String id,
    required final String matchId,
    required final String battingTeamId,
    required final String bowlingTeamId,
    required final int runs,
    required final int wickets,
    required final int overs,
    required final int balls,
    required final bool isComplete,
  }) = _$InningsImpl;

  factory _Innings.fromJson(Map<String, dynamic> json) = _$InningsImpl.fromJson;

  @override
  String get id;
  @override
  String get matchId;
  @override
  String get battingTeamId;
  @override
  String get bowlingTeamId;
  @override
  int get runs;
  @override
  int get wickets;
  @override
  int get overs;
  @override
  int get balls;
  @override
  bool get isComplete;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InningsImplCopyWith<_$InningsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
