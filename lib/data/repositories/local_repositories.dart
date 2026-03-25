import 'dart:async';
import 'package:hive/hive.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/ball_event.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/interfaces.dart';

class LocalMatchRepository implements MatchRepository {
  static final Map<String, Match> _matches = {};
  static final _controller = StreamController<List<Match>>.broadcast();
  static const String _matchesBoxName = 'matchesBox';
  static const String _matchesKey = 'matches';
  static bool _isHydrated = false;
  static Future<void>? _initFuture;

  Future<void> _ensureInitialized() {
    _initFuture ??= _hydrateFromHive();
    return _initFuture!;
  }

  Future<void> _hydrateFromHive() async {
    if (_isHydrated) return;
    final box = await Hive.openBox(_matchesBoxName);
    final raw = box.get(_matchesKey);
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          try {
            final json = Map<String, dynamic>.from(item);
            final match = Match.fromJson(json);
            _matches[match.id] = match;
          } catch (_) {
            // Ignore a single bad persisted row instead of failing app startup.
          }
        }
      }
    }
    _isHydrated = true;
  }

  Future<void> _persistToHive() async {
    final box = await Hive.openBox(_matchesBoxName);
    final serialized = _matches.values.map((m) => m.toJson()).toList();
    await box.put(_matchesKey, serialized);
  }

  void _notify() {
    final sorted = _matches.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _controller.add(sorted);
  }

  @override
  Future<void> createMatch(Match match) async {
    await _ensureInitialized();
    _matches[match.id] = match;
    await _persistToHive();
    _notify();
  }

  @override
  Future<void> updateMatch(Match match) async {
    await _ensureInitialized();
    _matches[match.id] = match;
    await _persistToHive();
    _notify();
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    await _ensureInitialized();
    _matches.remove(matchId);
    await _persistToHive();
    _notify();
  }

  @override
  Future<Match?> getMatch(String id) async {
    await _ensureInitialized();
    return _matches[id];
  }

  @override
  Stream<Match?> watchMatch(String id) async* {
    await _ensureInitialized();
    yield _matches[id];
    yield* _controller.stream.map((matches) {
      for (final match in matches) {
        if (match.id == id) return match;
      }
      return null;
    });
  }

  @override
  Future<List<Match>> getPastMatches() async {
    await _ensureInitialized();
    return _matches.values
        .where((m) => m.status == MatchStatus.completed)
        .toList();
  }

  @override
  Future<List<Match>> getLiveMatches() async {
    await _ensureInitialized();
    final live = _matches.values
        .where((m) => m.status == MatchStatus.live || m.status == MatchStatus.scheduled)
        .toList();
    live.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return live;
  }

  @override
  Stream<List<Match>> watchLiveMatches() async* {
    await _ensureInitialized();
    yield await getLiveMatches();
    yield* _controller.stream.map((matches) => matches
        .where((m) => m.status == MatchStatus.live || m.status == MatchStatus.scheduled)
        .toList());
  }
}

class LocalBallRepository implements BallRepository {
  static final List<BallEvent> _events = [];
  static final _controller = StreamController<List<BallEvent>>.broadcast();

  static const String _ballsBoxName = 'ballsBox';
  static const String _ballsKey = 'events';
  static bool _isHydrated = false;
  static Future<void>? _initFuture;
  static Box<dynamic>? _box;

  Future<void> _ensureInitialized() {
    _initFuture ??= _hydrateFromHive();
    return _initFuture!;
  }

  Future<void> _hydrateFromHive() async {
    if (_isHydrated) return;
    _box = await Hive.openBox(_ballsBoxName);
    final raw = _box!.get(_ballsKey);
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          try {
            final json = Map<String, dynamic>.from(item);
            final event = BallEvent.fromJson(json);
            _events.add(event);
          } catch (_) {
            // Ignore corrupted event rows to keep app usable in production.
          }
        }
      }
      _events.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    _isHydrated = true;
  }

  Future<void> _appendToHive(BallEvent event) async {
    final box = _box!;
    final stored = box.get(_ballsKey);
    final list = (stored is List) ? List<dynamic>.from(stored) : <dynamic>[];
    list.add(event.toJson());
    await box.put(_ballsKey, list);
  }

  Future<void> _persistFullToHive() async {
    final box = _box!;
    final serialized = _events.map((e) => e.toJson()).toList();
    await box.put(_ballsKey, serialized);
  }

  @override
  Future<void> recordBall(BallEvent event) async {
    await _ensureInitialized();
    _events.add(event);
    // Emit immediately so UI listeners update without waiting for disk I/O.
    _controller.add(List.from(_events));
    // Incremental write to avoid re-serializing the entire event list.
    // Fire-and-forget persistence to keep the scoring UI responsive.
    unawaited(
      _appendToHive(event).catchError((_) {
        // If persistence fails, we still keep the in-memory scoring state working.
      }),
    );
  }

  @override
  Stream<List<BallEvent>> watchBallEvents(String matchId, String? inningsId) async* {
    await _ensureInitialized();
    // Yield current events immediately
    yield _events
        .where((e) => e.matchId == matchId && (inningsId == null || e.inningsId == inningsId))
        .toList();

    // Then listen for updates
    yield* _controller.stream.map((events) => events
        .where((e) => e.matchId == matchId && (inningsId == null || e.inningsId == inningsId))
        .toList());
  }

  @override
  Future<void> updateBall(BallEvent event) async {
    await _ensureInitialized();
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      // Updates are less frequent than recordBall, so full persist is acceptable.
      await _persistFullToHive();
      _controller.add(List.from(_events));
    }
  }

  @override
  Future<void> deleteBall(String ballId) async {
    await _ensureInitialized();
    _events.removeWhere((e) => e.id == ballId);
    await _persistFullToHive();
    _controller.add(List.from(_events));
  }
}

class LocalTeamRepository implements TeamRepository {
  static final Map<String, Team> _teams = {};
  static final Map<String, List<Player>> _players = {};

  @override
  Future<void> createTeam(Team team) async {
    _teams[team.id] = team;
  }

  @override
  Future<List<Team>> getTeams() async {
    return _teams.values.toList();
  }

  @override
  Future<void> addPlayer(Player player) async {
    _players.putIfAbsent(player.teamId, () => []).add(player);
  }

  @override
  Future<List<Player>> getPlayers(String teamId) async {
    return _players[teamId] ?? [];
  }
}
