// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get teamAId => throw _privateConstructorUsedError;
  String get teamBId => throw _privateConstructorUsedError;
  int get oversLimit => throw _privateConstructorUsedError;
  String? get tossWinnerId => throw _privateConstructorUsedError;
  String? get tossDecision =>
      throw _privateConstructorUsedError; // 'bat' or 'bowl'
  MatchStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call({
    String id,
    String teamAId,
    String teamBId,
    int oversLimit,
    String? tossWinnerId,
    String? tossDecision,
    MatchStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamAId = null,
    Object? teamBId = null,
    Object? oversLimit = null,
    Object? tossWinnerId = freezed,
    Object? tossDecision = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            teamAId: null == teamAId
                ? _value.teamAId
                : teamAId // ignore: cast_nullable_to_non_nullable
                      as String,
            teamBId: null == teamBId
                ? _value.teamBId
                : teamBId // ignore: cast_nullable_to_non_nullable
                      as String,
            oversLimit: null == oversLimit
                ? _value.oversLimit
                : oversLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            tossWinnerId: freezed == tossWinnerId
                ? _value.tossWinnerId
                : tossWinnerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tossDecision: freezed == tossDecision
                ? _value.tossDecision
                : tossDecision // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MatchStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
    _$MatchImpl value,
    $Res Function(_$MatchImpl) then,
  ) = __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String teamAId,
    String teamBId,
    int oversLimit,
    String? tossWinnerId,
    String? tossDecision,
    MatchStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
    _$MatchImpl _value,
    $Res Function(_$MatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamAId = null,
    Object? teamBId = null,
    Object? oversLimit = null,
    Object? tossWinnerId = freezed,
    Object? tossDecision = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MatchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        teamAId: null == teamAId
            ? _value.teamAId
            : teamAId // ignore: cast_nullable_to_non_nullable
                  as String,
        teamBId: null == teamBId
            ? _value.teamBId
            : teamBId // ignore: cast_nullable_to_non_nullable
                  as String,
        oversLimit: null == oversLimit
            ? _value.oversLimit
            : oversLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        tossWinnerId: freezed == tossWinnerId
            ? _value.tossWinnerId
            : tossWinnerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tossDecision: freezed == tossDecision
            ? _value.tossDecision
            : tossDecision // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MatchStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.oversLimit,
    this.tossWinnerId,
    this.tossDecision,
    required this.status,
    required this.createdAt,
  });

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String teamAId;
  @override
  final String teamBId;
  @override
  final int oversLimit;
  @override
  final String? tossWinnerId;
  @override
  final String? tossDecision;
  // 'bat' or 'bowl'
  @override
  final MatchStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Match(id: $id, teamAId: $teamAId, teamBId: $teamBId, oversLimit: $oversLimit, tossWinnerId: $tossWinnerId, tossDecision: $tossDecision, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamAId, teamAId) || other.teamAId == teamAId) &&
            (identical(other.teamBId, teamBId) || other.teamBId == teamBId) &&
            (identical(other.oversLimit, oversLimit) ||
                other.oversLimit == oversLimit) &&
            (identical(other.tossWinnerId, tossWinnerId) ||
                other.tossWinnerId == tossWinnerId) &&
            (identical(other.tossDecision, tossDecision) ||
                other.tossDecision == tossDecision) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    teamAId,
    teamBId,
    oversLimit,
    tossWinnerId,
    tossDecision,
    status,
    createdAt,
  );

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(this);
  }
}

abstract class _Match implements Match {
  const factory _Match({
    required final String id,
    required final String teamAId,
    required final String teamBId,
    required final int oversLimit,
    final String? tossWinnerId,
    final String? tossDecision,
    required final MatchStatus status,
    required final DateTime createdAt,
  }) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get teamAId;
  @override
  String get teamBId;
  @override
  int get oversLimit;
  @override
  String? get tossWinnerId;
  @override
  String? get tossDecision; // 'bat' or 'bowl'
  @override
  MatchStatus get status;
  @override
  DateTime get createdAt;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
