import '../entities/match.dart';
import '../entities/ball_event.dart';
import '../entities/team.dart';
import '../entities/player.dart';

abstract class MatchRepository {
  Future<void> createMatch(Match match);
  Future<void> updateMatch(Match match);
  Future<void> deleteMatch(String matchId);
  Future<Match?> getMatch(String id);
  Stream<Match?> watchMatch(String id);
  Future<List<Match>> getPastMatches();
  Future<List<Match>> getLiveMatches();
  Stream<List<Match>> watchLiveMatches();
}

abstract class BallRepository {
  Future<void> recordBall(BallEvent event);
  Stream<List<BallEvent>> watchBallEvents(String matchId, String? inningsId);
  Future<void> updateBall(BallEvent event);
  Future<void> deleteBall(String ballId);
}

abstract class TeamRepository {
  Future<void> createTeam(Team team);
  Future<List<Team>> getTeams();
  Future<void> addPlayer(Player player);
  Future<List<Player>> getPlayers(String teamId);
}
