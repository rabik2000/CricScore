import 'package:cricket_scorer/application/providers/scoring_provider.dart';
import 'package:cricket_scorer/application/services/scoring_state.dart';
import 'package:cricket_scorer/domain/entities/ball_event.dart';
import 'package:cricket_scorer/domain/entities/match.dart';
import 'package:cricket_scorer/domain/repositories/interfaces.dart';
import 'package:cricket_scorer/presentation/screens/live_scoring_screen.dart';
import 'package:cricket_scorer/presentation/screens/live_scoring_components/scoreboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal fakes so [ScoringNotifier] can be constructed without Hive in tests.
class _FakeMatchRepo implements MatchRepository {
  @override
  Future<void> createMatch(Match match) async {}

  @override
  Future<void> deleteMatch(String matchId) async {}

  @override
  Future<List<Match>> getLiveMatches() async => [];

  @override
  Future<List<Match>> getPastMatches() async => [];

  @override
  Future<Match?> getMatch(String id) async => null;

  @override
  Future<void> updateMatch(Match match) async {}

  @override
  Stream<Match?> watchMatch(String id) => Stream.value(null);

  @override
  Stream<List<Match>> watchLiveMatches() => Stream.value([]);
}

class _FakeBallRepo implements BallRepository {
  @override
  Future<void> deleteBall(String ballId) async {}

  @override
  Future<void> recordBall(BallEvent event) async {}

  @override
  Future<void> updateBall(BallEvent event) async {}

  @override
  Stream<List<BallEvent>> watchBallEvents(String matchId, String? inningsId) =>
      Stream.value([]);
}

void main() {
  const testState = ScoringState(
    matchId: 'test-match',
    inningsId: 'innings1',
    teamAName: 'Warriors',
    teamBName: 'Titans',
    strikerId: 'Batsman 1',
    nonStrikerId: 'Batsman 2',
    bowlerId: 'Bowler 1',
    totalRuns: 0,
    totalWickets: 0,
    // Match the "everything visible" layout: show some recent balls and
    // ensure Batsmen + Bowler + Recent Balls widgets render populated UI.
    legalBallsThisOver: 3,
    totalLegalBalls: 3,
    currentOverBalls: ['W', 'W', 'W'],
    previousBowlers: [],
    bowlerNameToIndex: {'Bowler 1': 0},
    bowlerLegalBalls: {0: 3},
    bowlerDotBalls: {},
    bowlerWickets: {0: 3},
    bowlerRuns: {0: 0},
    isTeamABatting: true,
    // Show the "LAST MAN" chip and the swap/sync button (after a wicket).
    canEnableLastMan: true,
    lastBallWicket: true,
  );

  testWidgets(
    'LiveScoringScreen: scoreboard + keyboard visible (layout regression)',
    (tester) async {
      final fakeBall = _FakeBallRepo();
      final fakeMatch = _FakeMatchRepo();

      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ballRepositoryProvider.overrideWith((ref) => fakeBall),
            matchRepositoryProvider.overrideWith((ref) => fakeMatch),
            scoringProvider.overrideWith((ref) {
              final notifier = ScoringNotifier(
                ref.read(ballRepositoryProvider),
                ref.read(matchRepositoryProvider),
              );
              notifier.state = const AsyncValue.data(testState);
              return notifier;
            }),
          ],
          child: const MediaQuery(
            data: MediaQueryData(
              size: Size(400, 800),
              devicePixelRatio: 1,
            ),
            child: MaterialApp(
              home: LiveScoringScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final scrollFinder = find.byKey(const ValueKey('live_scoring_main_scroll'));
      expect(scrollFinder, findsOneWidget);
      // If [bottomNavigationBar] incorrectly expands to full screen, the scaffold gives the
      // body zero height and this scroll view collapses (regression: blank UI + floating keypad).
      expect(tester.getSize(scrollFinder).height, greaterThan(200));
      expect(find.byType(ScoreboardCard), findsOneWidget);
      expect(find.text('Warriors'), findsOneWidget);
      expect(find.text('UNDO LAST BALL'), findsOneWidget);
      // Batsmen area.
      expect(find.text('LAST MAN'), findsOneWidget);
      expect(find.text('SCORECARD'), findsOneWidget);

      // Bowling + recent balls.
      expect(find.text('BOWLING'), findsOneWidget);
      expect(find.text('CHANGE'), findsOneWidget);
      expect(find.text('Balls: 3'), findsOneWidget);

      // Full scoring keyboard labels.
      expect(find.text('WICKET'), findsOneWidget);
      expect(find.text('RUN-OUT'), findsOneWidget);
      expect(find.text('NB'), findsOneWidget);
      expect(find.text('WD'), findsOneWidget);

      // Sanity: should render at least one "0" somewhere in the UI (runs/balls/etc).
      expect(find.text('0'), findsWidgets);
    },
  );
}
