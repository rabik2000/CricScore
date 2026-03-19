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
          final json = Map<String, dynamic>.from(item);
          final match = Match.fromJson(json);
          _matches[match.id] = match;
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
    _controller.add(_matches.values.toList());
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
    return _matches.values
        .where((m) => m.status == MatchStatus.live || m.status == MatchStatus.scheduled)
        .toList();
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

  @override
  Future<void> recordBall(BallEvent event) async {
    _events.add(event);
    _controller.add(List.from(_events));
  }

  @override
  Stream<List<BallEvent>> watchBallEvents(String matchId, String? inningsId) async* {
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
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      _controller.add(List.from(_events));
    }
  }

  @override
  Future<void> deleteBall(String ballId) async {
    _events.removeWhere((e) => e.id == ballId);
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
