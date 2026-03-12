import '../../domain/entities/match.dart';
import '../../domain/repositories/interfaces.dart';
import 'scoring_engine.dart';
import 'scoring_state.dart';

/// Encapsulates match lifecycle logic (innings transitions, winner calculation),
/// extracted from ScoringNotifier.
class MatchLifecycleManager {
  /// Determines if the innings should auto-finish after a ball is recorded.
  /// Returns true if auto-finish conditions are met.
  static bool shouldAutoFinishInnings(ScoringState state, bool wicketJustFell) {
    return state.totalWickets >= 10 ||
        (state.isLastManMode && wicketJustFell);
  }

  /// Finishes the current innings.
  /// - If first innings: transitions to second innings.
  /// - If second innings: calculates the winner and marks match complete.
  static Future<ScoringState> finishInnings(
    ScoringState currentState,
    MatchRepository matchRepository,
  ) async {
    if (currentState.isMatchComplete) return currentState;

    if (currentState.isFirstInnings) {
      return ScoringEngine.transitionToSecondInnings(currentState);
    } else {
      // Second innings finish — calculate winner
      final winnerMsg = calculateWinner(currentState);

      final completedState = currentState.copyWith(
        isMatchComplete: true,
        winnerName: winnerMsg,
      );

      // Persist completed status
      await _updateMatchStatus(
        currentState.matchId,
        MatchStatus.completed,
        matchRepository,
      );

      return completedState;
    }
  }

  /// Calculates the winner based on the second innings state.
  static String calculateWinner(ScoringState state) {
    final battingTeam =
        state.isTeamABatting ? state.teamAName : state.teamBName;
    final bowlingTeam =
        state.isTeamABatting ? state.teamBName : state.teamAName;

    if (state.targetRuns != null) {
      if (state.totalRuns >= state.targetRuns!) {
        return battingTeam;
      } else if (state.totalRuns < state.targetRuns! - 1) {
        return bowlingTeam;
      } else {
        return 'MATCH TIED';
      }
    }
    return 'MATCH CONCLUDED';
  }

  static Future<void> _updateMatchStatus(
    String matchId,
    MatchStatus status,
    MatchRepository repository,
  ) async {
    final match = await repository.getMatch(matchId);
    if (match != null && match.status != status) {
      await repository.updateMatch(match.copyWith(status: status));
    }
  }
}
