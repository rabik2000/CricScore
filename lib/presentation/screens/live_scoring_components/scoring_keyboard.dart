import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../application/services/scoring_state.dart';
import '../../../../core/theme/app_theme.dart';
import 'action_button.dart';

class ScoringKeyboard extends ConsumerWidget {
  const ScoringKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needsBowler = ref.watch(scoringProvider.select((s) => 
      s.value == null || s.value!.bowlerId.trim().isEmpty
    ));

    void showSelectBowlerHint() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please select a bowler first!',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.emeraldColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionButton(
            label: 'UNDO LAST BALL',
            color: const Color(0xFFF0F9FF),
            textColor: const Color(0xFF0EA5E9),
            icon: Icons.undo_rounded,
            onTap: () async => await ref.read(scoringProvider.notifier).undo(),
          ),
          const SizedBox(height: 10),
          // Row 1: 0, 1, 2
          _KeyRow(children: [
            _Key(label: '0', ref: ref, runs: 0, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
            _Key(label: '1', ref: ref, runs: 1, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
            _Key(label: '2', ref: ref, runs: 2, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
          ]),
          const SizedBox(height: 10),
          // Row 2: 3, 4, 6
          _KeyRow(children: [
            _Key(label: '3', ref: ref, runs: 3, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
            _Key(label: '4', ref: ref, runs: 4, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
            _Key(label: '6', ref: ref, runs: 6, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint),
          ]),
          const SizedBox(height: 10),
          // Row 3: NB, WD (each takes half width)
          Row(
            children: [
              Expanded(child: _Key(label: 'NB', ref: ref, extraType: 'no_ball', isExtra: true, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint, height: 48)),
              const SizedBox(width: 10),
              Expanded(child: _Key(label: 'WD', ref: ref, extraType: 'wide', isExtra: true, needsBowler: needsBowler, onNeedBowler: showSelectBowlerHint, height: 48)),
            ],
          ),
          const SizedBox(height: 10),
          // Row 4: WICKET | RUN-OUT (equal width)
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'WICKET',
                  color: const Color(0xFFFF2D55),
                  onTap: needsBowler
                    ? showSelectBowlerHint
                    : () {
                        ref.read(scoringProvider.notifier).recordBall(
                          runsFromBat: 0, extraRuns: 0, wicket: true,
                        );
                      },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ActionButton(
                  label: 'RUN-OUT',
                  color: AppTheme.slateColor,
                  onTap: needsBowler
                    ? showSelectBowlerHint
                    : () {
                        final stateVal = ref.read(scoringProvider).value;
                        if (stateVal != null) _showRunOutDialog(context, ref, stateVal);
                      },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  final String label;
  final WidgetRef ref;
  final int runs;
  final String? extraType;
  final bool isExtra;
  final bool needsBowler;
  final VoidCallback? onNeedBowler;
  final double? height;

  const _Key({
    required this.label,
    required this.ref,
    this.runs = 0,
    this.extraType,
    this.isExtra = false,
    this.needsBowler = false,
    this.onNeedBowler,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isExtra ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC);
    final textColor = isExtra ? const Color(0xFFD97706) : AppTheme.slateColor;

    return SizedBox(
      height: height,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (needsBowler) { onNeedBowler?.call(); return; }
            if (extraType == 'wide') {
              ref.read(scoringProvider.notifier).recordBall(
                runsFromBat: 0, extraRuns: 1, extraType: 'wide',
              );
            } else if (extraType == 'no_ball') {
              _showNoBallDialog(context, ref);
            } else {
              ref.read(scoringProvider.notifier).recordBall(
                runsFromBat: extraType == null ? runs : 0,
                extraRuns: extraType != null ? 1 : 0,
                extraType: extraType,
              );
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isExtra ? Border.all(color: const Color(0xFFFEF3C7)) : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  final List<Widget> children;
  const _KeyRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: SizedBox(height: 52, child: children[i])),
          ],
        ],
      ),
    );
  }
}

void _showNoBallDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => Theme(
      data: AppTheme.darkTheme.copyWith(
        dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0F172A)),
      ),
      child: AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Ball Recorded',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'How many runs from the bat?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [0, 1, 2, 3, 4, 6].map((runs) {
                  return InkWell(
                    onTap: () {
                      ref.read(scoringProvider.notifier).recordBall(
                        runsFromBat: runs,
                        extraRuns: 1,
                        extraType: 'no_ball',
                      );
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$runs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showRunOutDialog(BuildContext context, WidgetRef ref, ScoringState state) {
  int runsDuringRunOut = 0;
  String dismissedId = state.strikerId;

  showDialog(
    context: context,
    builder: (context) => Theme(
      data: AppTheme.darkTheme.copyWith(
        dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0F172A)),
      ),
      child: StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          contentPadding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.slateColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_run_rounded, color: Colors.orangeAccent, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Run-Out Recorded',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                state.isLastManMode ? 'Solo batsman run out' : 'Select the dismissed batsman',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!state.isLastManMode) ...[
                const Text(
                  'WHO GOT OUT?',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DialogButton(
                        label: state.strikerId,
                        isSelected: dismissedId == state.strikerId,
                        onTap: () => setState(() => dismissedId = state.strikerId),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DialogButton(
                        label: state.nonStrikerId,
                        isSelected: dismissedId == state.nonStrikerId,
                        onTap: () => setState(() => dismissedId = state.nonStrikerId),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              const Text(
                'RUNS SCORED DURING RUN-OUT?',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(4, (index) {
                    final isSelected = runsDuringRunOut == index;
                    return InkWell(
                      onTap: () => setState(() => runsDuringRunOut = index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 55,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.emeraldColor : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.emeraldColor : Colors.white.withValues(alpha: 0.1),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(scoringProvider.notifier).recordBall(
                        runsFromBat: runsDuringRunOut,
                        extraRuns: 0,
                        wicket: true,
                        dismissalType: 'run_out',
                        dismissedPlayerId: state.isLastManMode ? state.strikerId : dismissedId,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.emeraldColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('RECORD WICKET', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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

class _DialogButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.emeraldColor : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.emeraldColor : Colors.white.withValues(alpha: 0.1),
             width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
