import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../application/providers/scoring_provider.dart';
import '../../application/services/scoring_state.dart';
import 'live_scoring_screen.dart';
import 'match_setup_components/choice_chip_btn.dart';
import 'match_setup_components/toss_coin.dart';

class MatchSetupScreen extends ConsumerStatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  ConsumerState<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends ConsumerState<MatchSetupScreen> {
  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  
  String _tossWinner = 'Team A';
  String _tossDecision = 'Bat First';
  bool _hasTossed = false;
  String? _tossResult;

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  void _onTossComplete(String result) {
    setState(() {
      _hasTossed = true;
      _tossResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bgColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // === CUSTOM APP BAR ===
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.slateColor, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'New Match',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.slateColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40), 
                        ],
                      ),
                    ),

                  // === TEAMS SECTION ===
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.slateColor.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('TEAMS', style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w900,
                                color: AppTheme.emeraldColor, letterSpacing: 1,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _TeamEntry(
                                controller: _teamAController,
                                label: 'TEAM A',
                                hint: 'Warriors',
                                alignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.bgColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.slateColor.withValues(alpha: 0.05)),
                              ),
                              child: const Text('VS', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.slateLight,
                              )),
                            ),
                            Expanded(
                              child: _TeamEntry(
                                controller: _teamBController,
                                label: 'TEAM B',
                                hint: 'Titans',
                                alignment: CrossAxisAlignment.end,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === TOSS SECTION ===
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.slateColor.withValues(alpha: 0.05),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TOSS', style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w900,
                                    color: AppTheme.slateColor, letterSpacing: 1.5,
                                  )),
                                  const SizedBox(height: 4),
                                  Text(
                                    _hasTossed ? 'Toss Result' : 'Tap to toss coin',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.slateLight.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (_hasTossed)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: (_tossResult == 'HEADS'
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF3B82F6)).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: (_tossResult == 'HEADS'
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF3B82F6)).withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    _tossResult!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: _tossResult == 'HEADS'
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF2563EB),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          
                          // Coin area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: TossCoin(onResult: _onTossComplete)),
                          ),

                          // Toss selections - Compacted
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.bgColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                _miniLabel('WHO WON THE TOSS?'),
                                const SizedBox(height: 10),
                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _teamAController,
                                  builder: (context, teamA, _) => ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: _teamBController,
                                    builder: (context, teamB, _) {
                                      final aName = teamA.text.trim().isEmpty ? 'Warriors' : teamA.text.trim();
                                      final bName = teamB.text.trim().isEmpty ? 'Titans' : teamB.text.trim();
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: ChoiceChipBtn(
                                              label: aName,
                                              isSelected: _tossWinner == 'Team A',
                                              onTap: () => setState(() => _tossWinner = 'Team A'),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ChoiceChipBtn(
                                              label: bName,
                                              isSelected: _tossWinner == 'Team B',
                                              onTap: () => setState(() => _tossWinner = 'Team B'),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _miniLabel('CHOSE TO'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ChoiceChipBtn(
                                        label: 'Bat First',
                                        isSelected: _tossDecision == 'Bat First',
                                        onTap: () => setState(() => _tossDecision = 'Bat First'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ChoiceChipBtn(
                                        label: 'Bowl First',
                                        isSelected: _tossDecision == 'Bowl First',
                                        onTap: () => setState(() => _tossDecision = 'Bowl First'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  // === START BUTTON ===
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppTheme.emeraldColor, Color(0xFF10B981)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.emeraldColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final teamAName = _teamAController.text.trim().isEmpty ? 'Warriors' : _teamAController.text.trim();
                          final teamBName = _teamBController.text.trim().isEmpty ? 'Titans' : _teamBController.text.trim();
                          
                          // Default player names
                          const strikerName = 'Batsman 1';
                          const nonStrikerName = 'Batsman 2';
                          const bowlerName = 'Bowler 1';

                          bool teamABatsFirst;
                          if (_tossWinner == 'Team A') {
                            teamABatsFirst = _tossDecision == 'Bat First';
                          } else {
                            teamABatsFirst = _tossDecision == 'Bowl First';
                          }

                          final initialState = ScoringState(
                            matchId: const Uuid().v4(),
                            inningsId: 'innings1',
                            teamAName: teamAName,
                            teamBName: teamBName,
                            strikerId: strikerName,
                            nonStrikerId: nonStrikerName,
                            bowlerId: bowlerName,
                            totalRuns: 0,
                            totalWickets: 0,
                            legalBallsThisOver: 0,
                            totalLegalBalls: 0,
                            currentOverBalls: [],
                            previousBowlers: [], // Start empty
                            isTeamABatting: teamABatsFirst,
                          );
                          
                          await ref.read(scoringProvider.notifier).init(initialState);
                          if (context.mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveScoringScreen()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sports_cricket_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'START MATCH',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
   );
  }

  Widget _miniLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(
        color: AppTheme.slateColor.withValues(alpha: 0.4),
        fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5,
      )),
    );
  }
}

class _TeamEntry extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final CrossAxisAlignment alignment;

  const _TeamEntry({
    required this.controller,
    required this.label,
    required this.hint,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.slateLight.withValues(alpha: 0.6),
        )),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          textAlign: alignment == CrossAxisAlignment.start ? TextAlign.start : TextAlign.end,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.slateColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.slateLight.withValues(alpha: 0.3)),
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
        ),
      ],
    );
  }
}
