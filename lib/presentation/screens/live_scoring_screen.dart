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
import 'home_screen.dart';

class LiveScoringScreen extends ConsumerWidget {
  const LiveScoringScreen({super.key});

  static bool _hasValidMatchState(dynamic stateValue) {
    if (stateValue == null) return false;
    return stateValue.teamAName.trim().isNotEmpty &&
        stateValue.teamBName.trim().isNotEmpty &&
        stateValue.strikerId.trim().isNotEmpty &&
        stateValue.nonStrikerId.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild root if loading/error status changes, not on every data change
    final isLoading = ref.watch(scoringProvider.select((s) => s.isLoading));
    final hasError = ref.watch(scoringProvider.select((s) => s.hasError));
    final hasData = ref.watch(scoringProvider.select((s) => s.hasValue));
    final stateValue = ref.watch(scoringProvider.select((s) => s.value));

    if (isLoading && !hasData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError && !hasData) {
      return const Scaffold(body: Center(child: Text('Error loading match state')));
    }

    final hasValidMatchState = _hasValidMatchState(stateValue);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Prevent Android back from returning to the toss page.
        ref.invalidate(matchesProvider);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      },
      child: ScaffoldMessenger(
        child: Scaffold(
          // Some OEMs (notably Xiaomi / MIUI) report stale or inflated viewInsets in
          // release builds, which shrinks the body and clips the scroll area. Keyboard
          // lives in [bottomNavigationBar], so we do not need the body to resize.
          resizeToAvoidBottomInset: false,
          backgroundColor: AppTheme.bgColor,
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mqH = MediaQuery.maybeOf(context)?.size.height;
                final maxH = constraints.hasBoundedHeight
                    ? constraints.maxHeight
                    : (mqH != null && mqH.isFinite && mqH > 0 ? mqH : 800.0);
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: maxH.isFinite && maxH > 0 ? maxH : 800.0,
                    ),
                    child: hasValidMatchState
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TopBar(),
                              Expanded(child: _ScrollableScoringBody()),
                            ],
                          )
                        : const _InvalidMatchStateView(),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: hasValidMatchState
              ? SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    // [Scaffold] gives bottomNavigationBar a max height of the *full screen*.
                    // A plain [Align] then expands to that height; the scaffold subtracts that
                    // full height from the body (often leaving **zero** body space). The bar is
                    // painted from y=0, so only the keypad shows — centered if alignment was
                    // [Alignment.center]. [heightFactor] shrink-wraps to the child height.
                    heightFactor: 1.0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const _BottomSection(),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _InvalidMatchStateView extends ConsumerWidget {
  const _InvalidMatchStateView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sports_cricket_rounded, size: 48, color: AppTheme.emeraldColor),
            const SizedBox(height: 12),
            const Text(
              'No active match data found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.slateColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start a new match or resume one from Home.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.slateLight),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(matchesProvider);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('GO TO HOME'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned [TopBar] + keyboard with a scrollable middle so nothing is clipped on short phones.
class _ScrollableScoringBody extends StatelessWidget {
  const _ScrollableScoringBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // On very short viewports, collapse less important vertical gaps.
        final sectionGap = constraints.maxHeight < 420 ? 8.0 : 12.0;

        return SingleChildScrollView(
          key: const ValueKey('live_scoring_main_scroll'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 6, 16, sectionGap),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScoreboardCard(),
              SizedBox(height: sectionGap),
              const BatsmenSection(),
              SizedBox(height: sectionGap),
              const BowlerSection(),
              SizedBox(height: sectionGap),
              const RecentBallsDisplay(),
            ],
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
