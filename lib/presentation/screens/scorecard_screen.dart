import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/scoring_provider.dart';
import '../../application/services/stats_calculator.dart';
import '../../application/services/scoring_state.dart';
import '../../domain/entities/ball_event.dart';
import '../../core/theme/app_theme.dart';

class ScorecardScreen extends ConsumerStatefulWidget {
  const ScorecardScreen({super.key});

  @override
  ConsumerState<ScorecardScreen> createState() => _ScorecardScreenState();
}

class _ScorecardScreenState extends ConsumerState<ScorecardScreen> {
  String? _selectedInningsId;

  @override
  Widget build(BuildContext context) {
    final scoringStateVal = ref.watch(scoringProvider);
    
    return scoringStateVal.when(
      data: (state) {
        // Initialize selected innings if not set
        _selectedInningsId ??= state.inningsId;

        return Scaffold(
          backgroundColor: AppTheme.bgColor,
          appBar: AppBar(
            title: Column(
              children: [
                const Text('Match Scorecard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                Text(
                  '${state.teamAName} vs ${state.teamBName}',
                  style: const TextStyle(fontSize: 10, color: AppTheme.slateLight, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ref.watch(matchEventsProvider(state.matchId)).when(
            data: (events) {
              final inningsEvents = events.where((e) => e.inningsId == _selectedInningsId).toList();
              
              // We need to know who was batting in the selected innings to calculate stats correctly
              // If it's the current innings, we use state.strikerId etc.
              // If it's the previous innings, we might need more info but StatsCalculator mostly relies on events.
              // However, current strikers are used for highlighting.
              
              final bool isViewingCurrentInnings = _selectedInningsId == state.inningsId;
              final striker = isViewingCurrentInnings ? state.strikerId : '';
              final nonStriker = isViewingCurrentInnings ? state.nonStrikerId : '';

              final batsmenStats = StatsCalculator.calculateBatsmenStats(inningsEvents, striker, nonStriker);
              final bowlerStats = StatsCalculator.calculateBowlersStats(inningsEvents);
              
              final extrasBreakdown = _calculateExtrasBreakdown(inningsEvents);
              final totalExtras = extrasBreakdown.values.fold<int>(0, (sum, val) => sum + val);

              // Calculate total runs/wickets/balls for the selected innings from events
              int totalRuns = 0;
              int wickets = 0;
              int legalBalls = 0;
              for (var e in inningsEvents) {
                totalRuns += e.totalRuns;
                if (e.wicket) wickets++;
                if (e.legalDelivery) legalBalls++;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InningsToggle(
                      state: state,
                      selectedInningsId: _selectedInningsId!,
                      onChanged: (id) => setState(() => _selectedInningsId = id),
                    ),
                    const SizedBox(height: 24),
                    _HeaderSection(
                      state: state, 
                      selectedInningsId: _selectedInningsId!,
                      totalRuns: totalRuns,
                      totalWickets: wickets,
                      totalLegalBalls: legalBalls,
                    ),
                    const SizedBox(height: 32),
                    _sectionHeader('BATTING'),
                    const SizedBox(height: 12),
                    _BattingSection(stats: batsmenStats),
                    const SizedBox(height: 16),
                    _ExtrasRow(total: totalExtras, breakdown: extrasBreakdown),
                    _TotalRow(runs: totalRuns, wickets: wickets, balls: legalBalls),
                    const SizedBox(height: 40),
                    _sectionHeader('BOWLING'),
                    const SizedBox(height: 12),
                    _BowlingSection(stats: bowlerStats),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading events: $err')),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppTheme.emeraldColor,
        letterSpacing: 1.5,
      ),
    );
  }

  Map<String, int> _calculateExtrasBreakdown(List<BallEvent> events) {
    final Map<String, int> breakdown = {'WD': 0, 'NB': 0, 'B': 0, 'LB': 0};
    for (final ball in events) {
      if (ball.extraType == 'wide') breakdown['WD'] = breakdown['WD']! + ball.extraRuns;
      if (ball.extraType == 'no_ball') breakdown['NB'] = breakdown['NB']! + ball.totalRuns; 
      if (ball.extraType == 'bye') breakdown['B'] = breakdown['B']! + ball.extraRuns;
      if (ball.extraType == 'leg_bye') breakdown['LB'] = breakdown['LB']! + ball.extraRuns;
    }
    return breakdown;
  }
}

class _InningsToggle extends StatelessWidget {
  final ScoringState state;
  final String selectedInningsId;
  final Function(String) onChanged;

  const _InningsToggle({
    required this.state,
    required this.selectedInningsId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which team batted first
    // If state.isFirstInnings is true, then state.isTeamABatting tells us who is batting IN THE FIRST INNINGS.
    // However, if we are in the second innings, state.isTeamABatting tells us who is batting IN THE SECOND INNINGS.
    
    // Let's assume:
    // Innings 1: Team that batted first.
    // Innings 2: Team that is batting second.
    
    String team1Name, team2Name;
    if (state.isFirstInnings) {
      team1Name = state.isTeamABatting ? state.teamAName : state.teamBName;
      team2Name = state.isTeamABatting ? state.teamBName : state.teamAName;
    } else {
      team1Name = state.isTeamABatting ? state.teamBName : state.teamAName;
      team2Name = state.isTeamABatting ? state.teamAName : state.teamBName;
    }

    return Row(
      children: [
        Expanded(
          child: _ToggleItem(
            label: team1Name,
            subLabel: '1st Innings',
            isSelected: selectedInningsId == 'innings1',
            onTap: () => onChanged('innings1'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ToggleItem(
            label: team2Name,
            subLabel: '2nd Innings',
            isSelected: selectedInningsId == 'innings2',
            onTap: state.isFirstInnings ? null : () => onChanged('innings2'),
            isDisabled: state.isFirstInnings,
          ),
        ),
      ],
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _ToggleItem({
    required this.label,
    required this.subLabel,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.emeraldColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.emeraldColor : AppTheme.slateColor.withValues(alpha: 0.1),
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: AppTheme.emeraldColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : (isDisabled ? AppTheme.slateLight.withValues(alpha: 0.4) : AppTheme.slateColor),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppTheme.slateLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider to fetch events for the scorecard in real-time
final matchEventsProvider = StreamProvider.family<List<BallEvent>, String>((ref, matchId) {
  final repo = ref.watch(ballRepositoryProvider);
  return repo.watchBallEvents(matchId, null); 
});

class _HeaderSection extends StatelessWidget {
  final ScoringState state;
  final String selectedInningsId;
  final int totalRuns;
  final int totalWickets;
  final int totalLegalBalls;

  const _HeaderSection({
    required this.state, 
    required this.selectedInningsId,
    required this.totalRuns,
    required this.totalWickets,
    required this.totalLegalBalls,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirst = selectedInningsId == 'innings1';
    
    String teamName;
    if (state.isFirstInnings) {
      teamName = isFirst 
          ? (state.isTeamABatting ? state.teamAName : state.teamBName)
          : (state.isTeamABatting ? state.teamBName : state.teamAName);
    } else {
      teamName = isFirst
          ? (state.isTeamABatting ? state.teamBName : state.teamAName)
          : (state.isTeamABatting ? state.teamAName : state.teamBName);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamName.toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                isFirst ? 'First Innings' : 'Second Innings', 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.slateColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalRuns/$totalWickets',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.emeraldColor),
              ),
              Text(
                '(${(totalLegalBalls ~/ 6)}.${(totalLegalBalls % 6)} Ov)',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.slateLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BattingSection extends StatelessWidget {
  final Map<String, BatsmanStats> stats;
  const _BattingSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppTheme.bgColor),
          ...stats.entries.map((e) => _BatsmanRow(name: e.key, stats: e.value)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 6, child: Text('BATSMAN', style: _headerStyle)),
          Expanded(flex: 2, child: Text('RUNS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('BALLS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('4s', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('6s', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text('S/RATE', style: _headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 0.5);
}

class _BatsmanRow extends StatelessWidget {
  final String name;
  final BatsmanStats stats;
  const _BatsmanRow({required this.name, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.bgColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: (stats.isStriking || stats.isNonStriker) ? AppTheme.emeraldColor : AppTheme.slateColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (stats.isStriking || stats.isNonStriker)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.star_rounded, size: 12, color: AppTheme.emeraldColor),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (stats.dismissalInfo != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.slateColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      stats.dismissalInfo!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900, // Very bold
                        color: AppTheme.slateColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  )
                else
                  Text(
                    'not out',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.emeraldColor.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('${stats.runs}', style: _statStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('${stats.balls}', style: _statStyleLight, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.fours}', style: _statStyleLight, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.sixes}', style: _statStyleLight, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text(stats.strikeRate.toStringAsFixed(1), style: _statStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static const _statStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateColor);
  static const _statStyleLight = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.slateLight);
}

class _ExtrasRow extends StatelessWidget {
  final int total;
  final Map<String, int> breakdown;
  const _ExtrasRow({required this.total, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    String details = breakdown.entries
        .where((e) => e.value > 0)
        .map((e) => '${e.key} ${e.value}')
        .join(', ');
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Extras', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.slateColor)),
          Row(
            children: [
              Text(
                total.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.slateColor),
              ),
              if (details.isNotEmpty)
                Text(
                  ' ($details)',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slateLight),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final int runs, wickets, balls;
  const _TotalRow({required this.runs, required this.wickets, required this.balls});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.slateColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Runs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.slateColor)),
          Text(
            '$runs ($wickets wkts, ${(balls ~/ 6)}.${(balls % 6)} ov)',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.slateColor),
          ),
        ],
      ),
    );
  }
}

class _BowlingSection extends StatelessWidget {
  final Map<String, BowlerStats> stats;
  const _BowlingSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppTheme.bgColor),
          ...stats.entries.map((e) => _BowlerRow(name: e.key, stats: e.value)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 7, child: Text('BOWLER', style: _headerStyle)),
          Expanded(flex: 2, child: Text('OVERS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('RUNS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('WICKETS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('DOTS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text('ECONOMY', style: _headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 0.5);
}

class _BowlerRow extends StatelessWidget {
  final String name;
  final BowlerStats stats;
  const _BowlerRow({required this.name, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.bgColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(flex: 2, child: Text(stats.overs.toStringAsFixed(1), style: _statStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.runsConceded}', style: _statStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.wickets}', style: _statStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.dotBalls}', style: _statStyleLight, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text(stats.economy.toStringAsFixed(1), style: _statStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static const _statStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateColor);
  static const _statStyleLight = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.slateLight);
}
