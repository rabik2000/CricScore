import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/scoring_provider.dart';
import '../../domain/entities/match.dart';
import 'home_screen.dart'; // We'll need access to _RecentMatchTile or a similar widget

class MatchHistoryScreen extends ConsumerWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We'll load matches manually in _loadAllMatches
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Matches'),
      ),
      body: FutureBuilder<List<Match>>(
        future: _loadAllMatches(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final matches = snapshot.data ?? [];
          if (matches.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: matches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final match = matches[index];
              // We'll reuse the tile logic from HomeScreen, 
              // but we need to make sure _RecentMatchTile is accessible or extracted.
              // For now, I'll use the one from HomeScreen if I make it public or export it.
              return RecentMatchTile(
                match: match,
                onDelete: () async {
                  await deleteMatch(ref, match.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Match>> _loadAllMatches(WidgetRef ref) async {
    final repo = ref.read(matchRepositoryProvider);
    final live = await repo.getLiveMatches();
    final past = await repo.getPastMatches();
    final all = [...live, ...past];
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }
}

// I will refactor HomeScreen to make _RecentMatchTile public as RecentMatchTile
