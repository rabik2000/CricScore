import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/scoring_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import 'live_scoring_screen.dart';
import 'match_setup_screen.dart';
import 'match_history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Text(
                    'CricScore'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.emeraldColor,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Professional Cricket\nScoring Made Simple',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Action Cards Section
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: 'New Match',
                          subtitle: 'Start scoring now',
                          icon: Icons.add_rounded,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MatchSetupScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ActionCard(
                          title: 'All Matches',
                          subtitle: 'View match history',
                          icon: Icons.history_rounded,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: theme.brightness == Brightness.light
                                ? [const Color(0xFF334155), const Color(0xFF0F172A)]
                                : [const Color(0xFF475569), const Color(0xFF1E293B)],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MatchHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Recent Matches Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Matches',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your latest scoring sessions',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MatchHistoryScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Match List
                  matchesAsync.when(
                    data: (matches) {
                      if (matches.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'No recent matches found.',
                              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
                            ),
                          ),
                        );
                      }
                      
                      // Show only 3 most recent matches
                      final recentMatches = matches.reversed.take(3).toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentMatches.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final match = recentMatches[index];
                          return RecentMatchTile(
                            match: match,
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: const Color(0xFF1E293B),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text(
                                    'Delete Match?',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                  ),
                                  content: Text(
                                    'This will permanently remove the match record.',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                                  ),
                                  actions: [
                                    ConfirmButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      label: 'CANCEL',
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                    ConfirmButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      label: 'DELETE',
                                      color: Colors.redAccent,
                                      isElevated: true,
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await deleteMatch(ref, match.id);
                              }
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, __) => Center(child: Text('Error: $err')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final bool isElevated;

  const ConfirmButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.color,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isElevated) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 170,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (gradient as LinearGradient).colors.first.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentMatchTile extends ConsumerWidget {
  final Match match;
  final VoidCallback onDelete;

  const RecentMatchTile({
    super.key,
    required this.match,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final summaryAsync = ref.watch(matchSummaryProvider(match));

    return summaryAsync.when(
      data: (summary) {
        if (summary == null) return const SizedBox.shrink();

        final dateStr = '${match.createdAt.day}/${match.createdAt.month}/${match.createdAt.year}';
        final isPaused = match.status != MatchStatus.completed;
        final overs = (summary.totalLegalBalls / 6).floor();
        final remainingBalls = summary.totalLegalBalls % 6;
        final oversStr = '$overs.$remainingBalls';

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: theme.brightness == Brightness.light ? 0.04 : 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatusBadge(status: match.status),
                          Text(
                            dateStr,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _TeamName(name: match.teamAId),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.emeraldColor,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    _TeamName(name: match.teamBId),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${summary.totalRuns}/${summary.totalWickets}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: colorScheme.onSurface,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '($oversStr overs)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline_rounded),
                            color: Colors.redAccent.withValues(alpha: 0.4),
                            tooltip: 'Delete match',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isPaused)
                  InkWell(
                    onTap: () async {
                      await ref.read(scoringProvider.notifier).resumeMatch(
                        match,
                        match.teamAId,
                        match.teamBId,
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiveScoringScreen()),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldColor.withValues(alpha: 0.1),
                        border: Border(top: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.05))),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 20, color: AppTheme.emeraldColor),
                          SizedBox(width: 8),
                          Text(
                            'RESUME MATCH',
                            style: TextStyle(
                              color: AppTheme.emeraldColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const _LoadingTile(),
      error: (err, _) => const SizedBox.shrink(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MatchStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == MatchStatus.completed;
    final color = isCompleted ? AppTheme.slateLight : const Color(0xFFF59E0B);
    final text = isCompleted ? 'COMPLETED' : 'PAUSED';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TeamName extends StatelessWidget {
  final String name;
  const _TeamName({required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      name.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 14,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
