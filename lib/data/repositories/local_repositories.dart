import 'dart:async';
import '../../domain/entities/match.dart';
import '../../domain/entities/ball_event.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/interfaces.dart';

class LocalMatchRepository implements MatchRepository {
  static final Map<String, Match> _matches = {};
  static final _controller = StreamController<List<Match>>.broadcast();

  void _notify() {
    _controller.add(_matches.values.toList());
  }

  @override
  Future<void> createMatch(Match match) async {
    _matches[match.id] = match;
    _notify();
  }

  @override
  Future<void> updateMatch(Match match) async {
    _matches[match.id] = match;
    _notify();
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    _matches.remove(matchId);
    _notify();
  }

  @override
  Future<Match?> getMatch(String id) async {
    return _matches[id];
  }

  @override
  Stream<Match?> watchMatch(String id) async* {
    yield _matches[id];
    yield* _controller.stream.map((matches) => matches.firstWhere((m) => m.id == id));
  }

  @override
  Future<List<Match>> getPastMatches() async {
    return _matches.values
        .where((m) => m.status == MatchStatus.completed)
        .toList();
  }

  @override
  Future<List<Match>> getLiveMatches() async {
    return _matches.values
        .where((m) => m.status == MatchStatus.live || m.status == MatchStatus.scheduled)
        .toList();
  }

  @override
  Stream<List<Match>> watchLiveMatches() async* {
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
