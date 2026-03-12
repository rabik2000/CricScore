import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';

class RecentBallsDisplay extends ConsumerWidget {
  const RecentBallsDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balls = ref.watch(scoringProvider.select((s) => s.value?.currentOverBalls ?? []));
    final legalBalls = ref.watch(scoringProvider.select((s) => s.value?.legalBallsThisOver ?? 0));
    
    return _RecentBalls(balls: balls, legalBalls: legalBalls);
  }
}

class _RecentBalls extends StatefulWidget {
  final List<String> balls;
  final int legalBalls;
  const _RecentBalls({required this.balls, required this.legalBalls});

  @override
  State<_RecentBalls> createState() => _RecentBallsState();
}

class _RecentBallsState extends State<_RecentBalls> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToEnd();
  }

  @override
  void didUpdateWidget(_RecentBalls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.balls.length != oldWidget.balls.length) {
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OVER: ', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.slateLight
              )),
              Text('Balls: ${widget.legalBalls}', style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.slateLight
              )),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
              ),
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.balls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => _BallCircle(label: widget.balls[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BallCircle extends StatelessWidget {
  final String label;
  const _BallCircle({required this.label});

  @override
  Widget build(BuildContext context) {
    bool isSpecial = label == 'WD' || label == 'NB' || label == 'W';
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSpecial ? const Color(0xFFFFFBEB) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: isSpecial ? const Color(0xFFFEF3C7) : const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: label == 'W' ? const Color(0xFFFF2D55) : (isSpecial ? const Color(0xFFD97706) : AppTheme.slateColor),
        ),
      ),
    );
  }
}
