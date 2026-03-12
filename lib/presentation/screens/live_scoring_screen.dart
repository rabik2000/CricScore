import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/scoring_provider.dart';
import '../../core/theme/app_theme.dart';
import 'live_scoring_components/bowler_section.dart';
import 'live_scoring_components/scoring_keyboard.dart';
import 'live_scoring_components/top_bar.dart';
import 'live_scoring_components/scoreboard_card.dart';
import 'live_scoring_components/recent_balls_display.dart';
import 'live_scoring_components/batsmen_section.dart';
import 'live_scoring_components/win_announcement.dart';

class LiveScoringScreen extends ConsumerWidget {
  const LiveScoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild root if loading/error status changes, not on every data change
    final isLoading = ref.watch(scoringProvider.select((s) => s.isLoading));
    final hasError = ref.watch(scoringProvider.select((s) => s.hasError));
    final hasData = ref.watch(scoringProvider.select((s) => s.hasValue));

    if (isLoading && !hasData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError && !hasData) {
      return const Scaffold(body: Center(child: Text('Error loading match state')));
    }

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            // Nest a ScaffoldMessenger + Scaffold so snackbars are
            // scoped to the mobile-width container, not the full browser.
            child: const ScaffoldMessenger(
              child: Scaffold(
                backgroundColor: AppTheme.bgColor,
                body: Column(
                  children: [
                    TopBar(),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _MainContent(),
                          ),
                          RecentBallsDisplay(),
                        ],
                      ),
                    ),
                    _BottomSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScoreboardCard(),
                BatsmenSection(),
                BowlerSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomSection extends ConsumerWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMatchComplete = ref.watch(scoringProvider.select((s) => s.value?.isMatchComplete ?? false));
    final winnerName = ref.watch(scoringProvider.select((s) => s.value?.winnerName ?? 'Team'));

    if (isMatchComplete) {
      return WinAnnouncement(winnerName: winnerName);
    }
    return const ScoringKeyboard();
  }
}
