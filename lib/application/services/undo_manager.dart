import '../../domain/repositories/interfaces.dart';
import 'scoring_state.dart';

/// Encapsulates undo history logic, extracted from ScoringNotifier.
class UndoManager {
  /// Adds the current state (without its own history) to the history list.
  /// Returns the updated history list.
  static List<ScoringState> addToHistory(ScoringState current) {
    final history = List<ScoringState>.from(current.history);
    history.add(current.copyWith(history: []));
    return history;
  }

  /// Pops the last state from history, deletes the last ball from the repo,
  /// and returns the restored state. Returns null if history is empty.
  static Future<ScoringState?> undo(
    ScoringState current,
    BallRepository ballRepository,
  ) async {
    if (current.history.isEmpty) return null;

    // Delete the last ball from the repository
    if (current.lastBallId != null) {
      await ballRepository.deleteBall(current.lastBallId!);
    }

    final history = List<ScoringState>.from(current.history);
    final previousState = history.removeLast();
    return previousState.copyWith(history: history);
  }
}
