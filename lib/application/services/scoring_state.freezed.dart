// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scoring_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoringState _$ScoringStateFromJson(Map<String, dynamic> json) {
  return _ScoringState.fromJson(json);
}

/// @nodoc
mixin _$ScoringState {
  String get matchId => throw _privateConstructorUsedError;
  String get inningsId => throw _privateConstructorUsedError;
  String get teamAName => throw _privateConstructorUsedError;
  String get teamBName => throw _privateConstructorUsedError;
  String get strikerId => throw _privateConstructorUsedError; // Used as Name
  String get nonStrikerId => throw _privateConstructorUsedError; // Used as Name
  int get strikerRuns => throw _privateConstructorUsedError;
  int get strikerBalls => throw _privateConstructorUsedError;
  int get nonStrikerRuns => throw _privateConstructorUsedError;
  int get nonStrikerBalls => throw _privateConstructorUsedError;
  String get bowlerId => throw _privateConstructorUsedError;
  String get lastBowlerId => throw _privateConstructorUsedError;
  int get totalRuns => throw _privateConstructorUsedError;
  int get totalWickets => throw _privateConstructorUsedError;
  int get legalBallsThisOver => throw _privateConstructorUsedError;
  int get totalLegalBalls => throw _privateConstructorUsedError;
  List<String> get currentOverBalls => throw _privateConstructorUsedError;
  List<String> get previousBowlers => throw _privateConstructorUsedError;
  bool get isTeamABatting =>
      throw _privateConstructorUsedError; // Bowler registry: stable index ↔ display name
  Map<String, int> get bowlerNameToIndex => throw _privateConstructorUsedError;
  int get nextBowlerIndex =>
      throw _privateConstructorUsedError; // Bowler stats keyed by stable integer index (not fragile string names)
  Map<int, int> get bowlerLegalBalls => throw _privateConstructorUsedError;
  Map<int, int> get bowlerDotBalls => throw _privateConstructorUsedError;
  Map<int, int> get bowlerWickets => throw _privateConstructorUsedError;
  Map<int, int> get bowlerRuns => throw _privateConstructorUsedError;
  bool get isFirstInnings => throw _privateConstructorUsedError;
  int? get targetRuns => throw _privateConstructorUsedError;
  bool get isMatchComplete => throw _privateConstructorUsedError;
  String? get winnerName => throw _privateConstructorUsedError;
  String? get lastBallId => throw _privateConstructorUsedError;
  bool get lastBallWicket => throw _privateConstructorUsedError;
  bool get isLastManMode => throw _privateConstructorUsedError;
  bool get canEnableLastMan => throw _privateConstructorUsedError;
  List<ScoringState> get history => throw _privateConstructorUsedError;

  /// Serializes this ScoringState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoringState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoringStateCopyWith<ScoringState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoringStateCopyWith<$Res> {
  factory $ScoringStateCopyWith(
    ScoringState value,
    $Res Function(ScoringState) then,
  ) = _$ScoringStateCopyWithImpl<$Res, ScoringState>;
  @useResult
  $Res call({
    String matchId,
    String inningsId,
    String teamAName,
    String teamBName,
    String strikerId,
    String nonStrikerId,
    int strikerRuns,
    int strikerBalls,
    int nonStrikerRuns,
    int nonStrikerBalls,
    String bowlerId,
    String lastBowlerId,
    int totalRuns,
    int totalWickets,
    int legalBallsThisOver,
    int totalLegalBalls,
    List<String> currentOverBalls,
    List<String> previousBowlers,
    bool isTeamABatting,
    Map<String, int> bowlerNameToIndex,
    int nextBowlerIndex,
    Map<int, int> bowlerLegalBalls,
    Map<int, int> bowlerDotBalls,
    Map<int, int> bowlerWickets,
    Map<int, int> bowlerRuns,
    bool isFirstInnings,
    int? targetRuns,
    bool isMatchComplete,
    String? winnerName,
    String? lastBallId,
    bool lastBallWicket,
    bool isLastManMode,
    bool canEnableLastMan,
    List<ScoringState> history,
  });
}

/// @nodoc
class _$ScoringStateCopyWithImpl<$Res, $Val extends ScoringState>
    implements $ScoringStateCopyWith<$Res> {
  _$ScoringStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoringState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? inningsId = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? strikerId = null,
    Object? nonStrikerId = null,
    Object? strikerRuns = null,
    Object? strikerBalls = null,
    Object? nonStrikerRuns = null,
    Object? nonStrikerBalls = null,
    Object? bowlerId = null,
    Object? lastBowlerId = null,
    Object? totalRuns = null,
    Object? totalWickets = null,
    Object? legalBallsThisOver = null,
    Object? totalLegalBalls = null,
    Object? currentOverBalls = null,
    Object? previousBowlers = null,
    Object? isTeamABatting = null,
    Object? bowlerNameToIndex = null,
    Object? nextBowlerIndex = null,
    Object? bowlerLegalBalls = null,
    Object? bowlerDotBalls = null,
    Object? bowlerWickets = null,
    Object? bowlerRuns = null,
    Object? isFirstInnings = null,
    Object? targetRuns = freezed,
    Object? isMatchComplete = null,
    Object? winnerName = freezed,
    Object? lastBallId = freezed,
    Object? lastBallWicket = null,
    Object? isLastManMode = null,
    Object? canEnableLastMan = null,
    Object? history = null,
  }) {
    return _then(
      _value.copyWith(
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            inningsId: null == inningsId
                ? _value.inningsId
                : inningsId // ignore: cast_nullable_to_non_nullable
                      as String,
            teamAName: null == teamAName
                ? _value.teamAName
                : teamAName // ignore: cast_nullable_to_non_nullable
                      as String,
            teamBName: null == teamBName
                ? _value.teamBName
                : teamBName // ignore: cast_nullable_to_non_nullable
                      as String,
            strikerId: null == strikerId
                ? _value.strikerId
                : strikerId // ignore: cast_nullable_to_non_nullable
                      as String,
            nonStrikerId: null == nonStrikerId
                ? _value.nonStrikerId
                : nonStrikerId // ignore: cast_nullable_to_non_nullable
                      as String,
            strikerRuns: null == strikerRuns
                ? _value.strikerRuns
                : strikerRuns // ignore: cast_nullable_to_non_nullable
                      as int,
            strikerBalls: null == strikerBalls
                ? _value.strikerBalls
                : strikerBalls // ignore: cast_nullable_to_non_nullable
                      as int,
            nonStrikerRuns: null == nonStrikerRuns
                ? _value.nonStrikerRuns
                : nonStrikerRuns // ignore: cast_nullable_to_non_nullable
                      as int,
            nonStrikerBalls: null == nonStrikerBalls
                ? _value.nonStrikerBalls
                : nonStrikerBalls // ignore: cast_nullable_to_non_nullable
                      as int,
            bowlerId: null == bowlerId
                ? _value.bowlerId
                : bowlerId // ignore: cast_nullable_to_non_nullable
                      as String,
            lastBowlerId: null == lastBowlerId
                ? _value.lastBowlerId
                : lastBowlerId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalRuns: null == totalRuns
                ? _value.totalRuns
                : totalRuns // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWickets: null == totalWickets
                ? _value.totalWickets
                : totalWickets // ignore: cast_nullable_to_non_nullable
                      as int,
            legalBallsThisOver: null == legalBallsThisOver
                ? _value.legalBallsThisOver
                : legalBallsThisOver // ignore: cast_nullable_to_non_nullable
                      as int,
            totalLegalBalls: null == totalLegalBalls
                ? _value.totalLegalBalls
                : totalLegalBalls // ignore: cast_nullable_to_non_nullable
                      as int,
            currentOverBalls: null == currentOverBalls
                ? _value.currentOverBalls
                : currentOverBalls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            previousBowlers: null == previousBowlers
                ? _value.previousBowlers
                : previousBowlers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isTeamABatting: null == isTeamABatting
                ? _value.isTeamABatting
                : isTeamABatting // ignore: cast_nullable_to_non_nullable
                      as bool,
            bowlerNameToIndex: null == bowlerNameToIndex
                ? _value.bowlerNameToIndex
                : bowlerNameToIndex // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            nextBowlerIndex: null == nextBowlerIndex
                ? _value.nextBowlerIndex
                : nextBowlerIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            bowlerLegalBalls: null == bowlerLegalBalls
                ? _value.bowlerLegalBalls
                : bowlerLegalBalls // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            bowlerDotBalls: null == bowlerDotBalls
                ? _value.bowlerDotBalls
                : bowlerDotBalls // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            bowlerWickets: null == bowlerWickets
                ? _value.bowlerWickets
                : bowlerWickets // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            bowlerRuns: null == bowlerRuns
                ? _value.bowlerRuns
                : bowlerRuns // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            isFirstInnings: null == isFirstInnings
                ? _value.isFirstInnings
                : isFirstInnings // ignore: cast_nullable_to_non_nullable
                      as bool,
            targetRuns: freezed == targetRuns
                ? _value.targetRuns
                : targetRuns // ignore: cast_nullable_to_non_nullable
                      as int?,
            isMatchComplete: null == isMatchComplete
                ? _value.isMatchComplete
                : isMatchComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            winnerName: freezed == winnerName
                ? _value.winnerName
                : winnerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastBallId: freezed == lastBallId
                ? _value.lastBallId
                : lastBallId // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastBallWicket: null == lastBallWicket
                ? _value.lastBallWicket
                : lastBallWicket // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLastManMode: null == isLastManMode
                ? _value.isLastManMode
                : isLastManMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            canEnableLastMan: null == canEnableLastMan
                ? _value.canEnableLastMan
                : canEnableLastMan // ignore: cast_nullable_to_non_nullable
                      as bool,
            history: null == history
                ? _value.history
                : history // ignore: cast_nullable_to_non_nullable
                      as List<ScoringState>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoringStateImplCopyWith<$Res>
    implements $ScoringStateCopyWith<$Res> {
  factory _$$ScoringStateImplCopyWith(
    _$ScoringStateImpl value,
    $Res Function(_$ScoringStateImpl) then,
  ) = __$$ScoringStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String matchId,
    String inningsId,
    String teamAName,
    String teamBName,
    String strikerId,
    String nonStrikerId,
    int strikerRuns,
    int strikerBalls,
    int nonStrikerRuns,
    int nonStrikerBalls,
    String bowlerId,
    String lastBowlerId,
    int totalRuns,
    int totalWickets,
    int legalBallsThisOver,
    int totalLegalBalls,
    List<String> currentOverBalls,
    List<String> previousBowlers,
    bool isTeamABatting,
    Map<String, int> bowlerNameToIndex,
    int nextBowlerIndex,
    Map<int, int> bowlerLegalBalls,
    Map<int, int> bowlerDotBalls,
    Map<int, int> bowlerWickets,
    Map<int, int> bowlerRuns,
    bool isFirstInnings,
    int? targetRuns,
    bool isMatchComplete,
    String? winnerName,
    String? lastBallId,
    bool lastBallWicket,
    bool isLastManMode,
    bool canEnableLastMan,
    List<ScoringState> history,
  });
}

/// @nodoc
class __$$ScoringStateImplCopyWithImpl<$Res>
    extends _$ScoringStateCopyWithImpl<$Res, _$ScoringStateImpl>
    implements _$$ScoringStateImplCopyWith<$Res> {
  __$$ScoringStateImplCopyWithImpl(
    _$ScoringStateImpl _value,
    $Res Function(_$ScoringStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoringState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? inningsId = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? strikerId = null,
    Object? nonStrikerId = null,
    Object? strikerRuns = null,
    Object? strikerBalls = null,
    Object? nonStrikerRuns = null,
    Object? nonStrikerBalls = null,
    Object? bowlerId = null,
    Object? lastBowlerId = null,
    Object? totalRuns = null,
    Object? totalWickets = null,
    Object? legalBallsThisOver = null,
    Object? totalLegalBalls = null,
    Object? currentOverBalls = null,
    Object? previousBowlers = null,
    Object? isTeamABatting = null,
    Object? bowlerNameToIndex = null,
    Object? nextBowlerIndex = null,
    Object? bowlerLegalBalls = null,
    Object? bowlerDotBalls = null,
    Object? bowlerWickets = null,
    Object? bowlerRuns = null,
    Object? isFirstInnings = null,
    Object? targetRuns = freezed,
    Object? isMatchComplete = null,
    Object? winnerName = freezed,
    Object? lastBallId = freezed,
    Object? lastBallWicket = null,
    Object? isLastManMode = null,
    Object? canEnableLastMan = null,
    Object? history = null,
  }) {
    return _then(
      _$ScoringStateImpl(
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        inningsId: null == inningsId
            ? _value.inningsId
            : inningsId // ignore: cast_nullable_to_non_nullable
                  as String,
        teamAName: null == teamAName
            ? _value.teamAName
            : teamAName // ignore: cast_nullable_to_non_nullable
                  as String,
        teamBName: null == teamBName
            ? _value.teamBName
            : teamBName // ignore: cast_nullable_to_non_nullable
                  as String,
        strikerId: null == strikerId
            ? _value.strikerId
            : strikerId // ignore: cast_nullable_to_non_nullable
                  as String,
        nonStrikerId: null == nonStrikerId
            ? _value.nonStrikerId
            : nonStrikerId // ignore: cast_nullable_to_non_nullable
                  as String,
        strikerRuns: null == strikerRuns
            ? _value.strikerRuns
            : strikerRuns // ignore: cast_nullable_to_non_nullable
                  as int,
        strikerBalls: null == strikerBalls
            ? _value.strikerBalls
            : strikerBalls // ignore: cast_nullable_to_non_nullable
                  as int,
        nonStrikerRuns: null == nonStrikerRuns
            ? _value.nonStrikerRuns
            : nonStrikerRuns // ignore: cast_nullable_to_non_nullable
                  as int,
        nonStrikerBalls: null == nonStrikerBalls
            ? _value.nonStrikerBalls
            : nonStrikerBalls // ignore: cast_nullable_to_non_nullable
                  as int,
        bowlerId: null == bowlerId
            ? _value.bowlerId
            : bowlerId // ignore: cast_nullable_to_non_nullable
                  as String,
        lastBowlerId: null == lastBowlerId
            ? _value.lastBowlerId
            : lastBowlerId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalRuns: null == totalRuns
            ? _value.totalRuns
            : totalRuns // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWickets: null == totalWickets
            ? _value.totalWickets
            : totalWickets // ignore: cast_nullable_to_non_nullable
                  as int,
        legalBallsThisOver: null == legalBallsThisOver
            ? _value.legalBallsThisOver
            : legalBallsThisOver // ignore: cast_nullable_to_non_nullable
                  as int,
        totalLegalBalls: null == totalLegalBalls
            ? _value.totalLegalBalls
            : totalLegalBalls // ignore: cast_nullable_to_non_nullable
                  as int,
        currentOverBalls: null == currentOverBalls
            ? _value._currentOverBalls
            : currentOverBalls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        previousBowlers: null == previousBowlers
            ? _value._previousBowlers
            : previousBowlers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isTeamABatting: null == isTeamABatting
            ? _value.isTeamABatting
            : isTeamABatting // ignore: cast_nullable_to_non_nullable
                  as bool,
        bowlerNameToIndex: null == bowlerNameToIndex
            ? _value._bowlerNameToIndex
            : bowlerNameToIndex // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        nextBowlerIndex: null == nextBowlerIndex
            ? _value.nextBowlerIndex
            : nextBowlerIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        bowlerLegalBalls: null == bowlerLegalBalls
            ? _value._bowlerLegalBalls
            : bowlerLegalBalls // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        bowlerDotBalls: null == bowlerDotBalls
            ? _value._bowlerDotBalls
            : bowlerDotBalls // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        bowlerWickets: null == bowlerWickets
            ? _value._bowlerWickets
            : bowlerWickets // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        bowlerRuns: null == bowlerRuns
            ? _value._bowlerRuns
            : bowlerRuns // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        isFirstInnings: null == isFirstInnings
            ? _value.isFirstInnings
            : isFirstInnings // ignore: cast_nullable_to_non_nullable
                  as bool,
        targetRuns: freezed == targetRuns
            ? _value.targetRuns
            : targetRuns // ignore: cast_nullable_to_non_nullable
                  as int?,
        isMatchComplete: null == isMatchComplete
            ? _value.isMatchComplete
            : isMatchComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        winnerName: freezed == winnerName
            ? _value.winnerName
            : winnerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastBallId: freezed == lastBallId
            ? _value.lastBallId
            : lastBallId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastBallWicket: null == lastBallWicket
            ? _value.lastBallWicket
            : lastBallWicket // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLastManMode: null == isLastManMode
            ? _value.isLastManMode
            : isLastManMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        canEnableLastMan: null == canEnableLastMan
            ? _value.canEnableLastMan
            : canEnableLastMan // ignore: cast_nullable_to_non_nullable
                  as bool,
        history: null == history
            ? _value._history
            : history // ignore: cast_nullable_to_non_nullable
                  as List<ScoringState>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoringStateImpl implements _ScoringState {
  const _$ScoringStateImpl({
    required this.matchId,
    required this.inningsId,
    required this.teamAName,
    required this.teamBName,
    required this.strikerId,
    required this.nonStrikerId,
    this.strikerRuns = 0,
    this.strikerBalls = 0,
    this.nonStrikerRuns = 0,
    this.nonStrikerBalls = 0,
    required this.bowlerId,
    this.lastBowlerId = '',
    required this.totalRuns,
    required this.totalWickets,
    required this.legalBallsThisOver,
    required this.totalLegalBalls,
    required final List<String> currentOverBalls,
    required final List<String> previousBowlers,
    this.isTeamABatting = true,
    final Map<String, int> bowlerNameToIndex = const {},
    this.nextBowlerIndex = 0,
    final Map<int, int> bowlerLegalBalls = const {},
    final Map<int, int> bowlerDotBalls = const {},
    final Map<int, int> bowlerWickets = const {},
    final Map<int, int> bowlerRuns = const {},
    this.isFirstInnings = true,
    this.targetRuns,
    this.isMatchComplete = false,
    this.winnerName,
    this.lastBallId,
    this.lastBallWicket = false,
    this.isLastManMode = false,
    this.canEnableLastMan = false,
    final List<ScoringState> history = const [],
  }) : _currentOverBalls = currentOverBalls,
       _previousBowlers = previousBowlers,
       _bowlerNameToIndex = bowlerNameToIndex,
       _bowlerLegalBalls = bowlerLegalBalls,
       _bowlerDotBalls = bowlerDotBalls,
       _bowlerWickets = bowlerWickets,
       _bowlerRuns = bowlerRuns,
       _history = history;

  factory _$ScoringStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoringStateImplFromJson(json);

  @override
  final String matchId;
  @override
  final String inningsId;
  @override
  final String teamAName;
  @override
  final String teamBName;
  @override
  final String strikerId;
  // Used as Name
  @override
  final String nonStrikerId;
  // Used as Name
  @override
  @JsonKey()
  final int strikerRuns;
  @override
  @JsonKey()
  final int strikerBalls;
  @override
  @JsonKey()
  final int nonStrikerRuns;
  @override
  @JsonKey()
  final int nonStrikerBalls;
  @override
  final String bowlerId;
  @override
  @JsonKey()
  final String lastBowlerId;
  @override
  final int totalRuns;
  @override
  final int totalWickets;
  @override
  final int legalBallsThisOver;
  @override
  final int totalLegalBalls;
  final List<String> _currentOverBalls;
  @override
  List<String> get currentOverBalls {
    if (_currentOverBalls is EqualUnmodifiableListView)
      return _currentOverBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentOverBalls);
  }

  final List<String> _previousBowlers;
  @override
  List<String> get previousBowlers {
    if (_previousBowlers is EqualUnmodifiableListView) return _previousBowlers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previousBowlers);
  }

  @override
  @JsonKey()
  final bool isTeamABatting;
  // Bowler registry: stable index ↔ display name
  final Map<String, int> _bowlerNameToIndex;
  // Bowler registry: stable index ↔ display name
  @override
  @JsonKey()
  Map<String, int> get bowlerNameToIndex {
    if (_bowlerNameToIndex is EqualUnmodifiableMapView)
      return _bowlerNameToIndex;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bowlerNameToIndex);
  }

  @override
  @JsonKey()
  final int nextBowlerIndex;
  // Bowler stats keyed by stable integer index (not fragile string names)
  final Map<int, int> _bowlerLegalBalls;
  // Bowler stats keyed by stable integer index (not fragile string names)
  @override
  @JsonKey()
  Map<int, int> get bowlerLegalBalls {
    if (_bowlerLegalBalls is EqualUnmodifiableMapView) return _bowlerLegalBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bowlerLegalBalls);
  }

  final Map<int, int> _bowlerDotBalls;
  @override
  @JsonKey()
  Map<int, int> get bowlerDotBalls {
    if (_bowlerDotBalls is EqualUnmodifiableMapView) return _bowlerDotBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bowlerDotBalls);
  }

  final Map<int, int> _bowlerWickets;
  @override
  @JsonKey()
  Map<int, int> get bowlerWickets {
    if (_bowlerWickets is EqualUnmodifiableMapView) return _bowlerWickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bowlerWickets);
  }

  final Map<int, int> _bowlerRuns;
  @override
  @JsonKey()
  Map<int, int> get bowlerRuns {
    if (_bowlerRuns is EqualUnmodifiableMapView) return _bowlerRuns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bowlerRuns);
  }

  @override
  @JsonKey()
  final bool isFirstInnings;
  @override
  final int? targetRuns;
  @override
  @JsonKey()
  final bool isMatchComplete;
  @override
  final String? winnerName;
  @override
  final String? lastBallId;
  @override
  @JsonKey()
  final bool lastBallWicket;
  @override
  @JsonKey()
  final bool isLastManMode;
  @override
  @JsonKey()
  final bool canEnableLastMan;
  final List<ScoringState> _history;
  @override
  @JsonKey()
  List<ScoringState> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'ScoringState(matchId: $matchId, inningsId: $inningsId, teamAName: $teamAName, teamBName: $teamBName, strikerId: $strikerId, nonStrikerId: $nonStrikerId, strikerRuns: $strikerRuns, strikerBalls: $strikerBalls, nonStrikerRuns: $nonStrikerRuns, nonStrikerBalls: $nonStrikerBalls, bowlerId: $bowlerId, lastBowlerId: $lastBowlerId, totalRuns: $totalRuns, totalWickets: $totalWickets, legalBallsThisOver: $legalBallsThisOver, totalLegalBalls: $totalLegalBalls, currentOverBalls: $currentOverBalls, previousBowlers: $previousBowlers, isTeamABatting: $isTeamABatting, bowlerNameToIndex: $bowlerNameToIndex, nextBowlerIndex: $nextBowlerIndex, bowlerLegalBalls: $bowlerLegalBalls, bowlerDotBalls: $bowlerDotBalls, bowlerWickets: $bowlerWickets, bowlerRuns: $bowlerRuns, isFirstInnings: $isFirstInnings, targetRuns: $targetRuns, isMatchComplete: $isMatchComplete, winnerName: $winnerName, lastBallId: $lastBallId, lastBallWicket: $lastBallWicket, isLastManMode: $isLastManMode, canEnableLastMan: $canEnableLastMan, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoringStateImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.inningsId, inningsId) ||
                other.inningsId == inningsId) &&
            (identical(other.teamAName, teamAName) ||
                other.teamAName == teamAName) &&
            (identical(other.teamBName, teamBName) ||
                other.teamBName == teamBName) &&
            (identical(other.strikerId, strikerId) ||
                other.strikerId == strikerId) &&
            (identical(other.nonStrikerId, nonStrikerId) ||
                other.nonStrikerId == nonStrikerId) &&
            (identical(other.strikerRuns, strikerRuns) ||
                other.strikerRuns == strikerRuns) &&
            (identical(other.strikerBalls, strikerBalls) ||
                other.strikerBalls == strikerBalls) &&
            (identical(other.nonStrikerRuns, nonStrikerRuns) ||
                other.nonStrikerRuns == nonStrikerRuns) &&
            (identical(other.nonStrikerBalls, nonStrikerBalls) ||
                other.nonStrikerBalls == nonStrikerBalls) &&
            (identical(other.bowlerId, bowlerId) ||
                other.bowlerId == bowlerId) &&
            (identical(other.lastBowlerId, lastBowlerId) ||
                other.lastBowlerId == lastBowlerId) &&
            (identical(other.totalRuns, totalRuns) ||
                other.totalRuns == totalRuns) &&
            (identical(other.totalWickets, totalWickets) ||
                other.totalWickets == totalWickets) &&
            (identical(other.legalBallsThisOver, legalBallsThisOver) ||
                other.legalBallsThisOver == legalBallsThisOver) &&
            (identical(other.totalLegalBalls, totalLegalBalls) ||
                other.totalLegalBalls == totalLegalBalls) &&
            const DeepCollectionEquality().equals(
              other._currentOverBalls,
              _currentOverBalls,
            ) &&
            const DeepCollectionEquality().equals(
              other._previousBowlers,
              _previousBowlers,
            ) &&
            (identical(other.isTeamABatting, isTeamABatting) ||
                other.isTeamABatting == isTeamABatting) &&
            const DeepCollectionEquality().equals(
              other._bowlerNameToIndex,
              _bowlerNameToIndex,
            ) &&
            (identical(other.nextBowlerIndex, nextBowlerIndex) ||
                other.nextBowlerIndex == nextBowlerIndex) &&
            const DeepCollectionEquality().equals(
              other._bowlerLegalBalls,
              _bowlerLegalBalls,
            ) &&
            const DeepCollectionEquality().equals(
              other._bowlerDotBalls,
              _bowlerDotBalls,
            ) &&
            const DeepCollectionEquality().equals(
              other._bowlerWickets,
              _bowlerWickets,
            ) &&
            const DeepCollectionEquality().equals(
              other._bowlerRuns,
              _bowlerRuns,
            ) &&
            (identical(other.isFirstInnings, isFirstInnings) ||
                other.isFirstInnings == isFirstInnings) &&
            (identical(other.targetRuns, targetRuns) ||
                other.targetRuns == targetRuns) &&
            (identical(other.isMatchComplete, isMatchComplete) ||
                other.isMatchComplete == isMatchComplete) &&
            (identical(other.winnerName, winnerName) ||
                other.winnerName == winnerName) &&
            (identical(other.lastBallId, lastBallId) ||
                other.lastBallId == lastBallId) &&
            (identical(other.lastBallWicket, lastBallWicket) ||
                other.lastBallWicket == lastBallWicket) &&
            (identical(other.isLastManMode, isLastManMode) ||
                other.isLastManMode == isLastManMode) &&
            (identical(other.canEnableLastMan, canEnableLastMan) ||
                other.canEnableLastMan == canEnableLastMan) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    matchId,
    inningsId,
    teamAName,
    teamBName,
    strikerId,
    nonStrikerId,
    strikerRuns,
    strikerBalls,
    nonStrikerRuns,
    nonStrikerBalls,
    bowlerId,
    lastBowlerId,
    totalRuns,
    totalWickets,
    legalBallsThisOver,
    totalLegalBalls,
    const DeepCollectionEquality().hash(_currentOverBalls),
    const DeepCollectionEquality().hash(_previousBowlers),
    isTeamABatting,
    const DeepCollectionEquality().hash(_bowlerNameToIndex),
    nextBowlerIndex,
    const DeepCollectionEquality().hash(_bowlerLegalBalls),
    const DeepCollectionEquality().hash(_bowlerDotBalls),
    const DeepCollectionEquality().hash(_bowlerWickets),
    const DeepCollectionEquality().hash(_bowlerRuns),
    isFirstInnings,
    targetRuns,
    isMatchComplete,
    winnerName,
    lastBallId,
    lastBallWicket,
    isLastManMode,
    canEnableLastMan,
    const DeepCollectionEquality().hash(_history),
  ]);

  /// Create a copy of ScoringState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoringStateImplCopyWith<_$ScoringStateImpl> get copyWith =>
      __$$ScoringStateImplCopyWithImpl<_$ScoringStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoringStateImplToJson(this);
  }
}

abstract class _ScoringState implements ScoringState {
  const factory _ScoringState({
    required final String matchId,
    required final String inningsId,
    required final String teamAName,
    required final String teamBName,
    required final String strikerId,
    required final String nonStrikerId,
    final int strikerRuns,
    final int strikerBalls,
    final int nonStrikerRuns,
    final int nonStrikerBalls,
    required final String bowlerId,
    final String lastBowlerId,
    required final int totalRuns,
    required final int totalWickets,
    required final int legalBallsThisOver,
    required final int totalLegalBalls,
    required final List<String> currentOverBalls,
    required final List<String> previousBowlers,
    final bool isTeamABatting,
    final Map<String, int> bowlerNameToIndex,
    final int nextBowlerIndex,
    final Map<int, int> bowlerLegalBalls,
    final Map<int, int> bowlerDotBalls,
    final Map<int, int> bowlerWickets,
    final Map<int, int> bowlerRuns,
    final bool isFirstInnings,
    final int? targetRuns,
    final bool isMatchComplete,
    final String? winnerName,
    final String? lastBallId,
    final bool lastBallWicket,
    final bool isLastManMode,
    final bool canEnableLastMan,
    final List<ScoringState> history,
  }) = _$ScoringStateImpl;

  factory _ScoringState.fromJson(Map<String, dynamic> json) =
      _$ScoringStateImpl.fromJson;

  @override
  String get matchId;
  @override
  String get inningsId;
  @override
  String get teamAName;
  @override
  String get teamBName;
  @override
  String get strikerId; // Used as Name
  @override
  String get nonStrikerId; // Used as Name
  @override
  int get strikerRuns;
  @override
  int get strikerBalls;
  @override
  int get nonStrikerRuns;
  @override
  int get nonStrikerBalls;
  @override
  String get bowlerId;
  @override
  String get lastBowlerId;
  @override
  int get totalRuns;
  @override
  int get totalWickets;
  @override
  int get legalBallsThisOver;
  @override
  int get totalLegalBalls;
  @override
  List<String> get currentOverBalls;
  @override
  List<String> get previousBowlers;
  @override
  bool get isTeamABatting; // Bowler registry: stable index ↔ display name
  @override
  Map<String, int> get bowlerNameToIndex;
  @override
  int get nextBowlerIndex; // Bowler stats keyed by stable integer index (not fragile string names)
  @override
  Map<int, int> get bowlerLegalBalls;
  @override
  Map<int, int> get bowlerDotBalls;
  @override
  Map<int, int> get bowlerWickets;
  @override
  Map<int, int> get bowlerRuns;
  @override
  bool get isFirstInnings;
  @override
  int? get targetRuns;
  @override
  bool get isMatchComplete;
  @override
  String? get winnerName;
  @override
  String? get lastBallId;
  @override
  bool get lastBallWicket;
  @override
  bool get isLastManMode;
  @override
  bool get canEnableLastMan;
  @override
  List<ScoringState> get history;

  /// Create a copy of ScoringState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoringStateImplCopyWith<_$ScoringStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
