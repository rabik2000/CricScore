import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TossCoin extends StatefulWidget {
  final ValueChanged<String> onResult;
  const TossCoin({super.key, required this.onResult});

  @override
  State<TossCoin> createState() => _TossCoinState();
}

class _TossCoinState extends State<TossCoin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _result;
  bool _isSpinning = false;
  bool _hasTossed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toss() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _hasTossed = false;
      _result = null;
    });
    _controller.forward(from: 0).then((_) {
      final result = (DateTime.now().millisecond % 2 == 0) ? 'HEADS' : 'TAILS';
      setState(() {
        _isSpinning = false;
        _hasTossed = true;
        _result = result;
      });
      widget.onResult(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toss,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_hasTossed && !_isSpinning)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_rounded, size: 14, color: AppTheme.slateLight),
                  SizedBox(width: 6),
                  Text('TAP TO TOSS', style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w900,
                    color: AppTheme.slateLight, letterSpacing: 1.5,
                  )),
                ],
              ),
            ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final value = _animation.value;
              bool showHeads;
              if (_isSpinning) {
                showHeads = (value * 14).floor() % 2 == 0;
              } else if (_hasTossed) {
                showHeads = _result == 'HEADS';
              } else {
                showHeads = true;
              }

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value * 3.14159 * 14)
                  ..scale((1.0 + (value < 0.5 ? value : 1.0 - value) * 0.3)),
                child: _ProgrammaticCoin(showHeads: showHeads, size: 120),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProgrammaticCoin extends StatelessWidget {
  final bool showHeads;
  final double size;
  const _ProgrammaticCoin({required this.showHeads, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: showHeads
              ? [const Color(0xFFFFF7D6), const Color(0xFFFFD700), const Color(0xFFB8860B)]
              : [const Color(0xFFE8EDF5), const Color(0xFFB0BEC5), const Color(0xFF78909C)],
        ),
        border: Border.all(
          color: showHeads ? const Color(0xFFDAA520) : const Color(0xFF90A4AE),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (showHeads ? const Color(0xFFFFD700) : const Color(0xFF90A4AE)).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.75,
          height: size * 0.75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: showHeads
                  ? const Color(0xFFDAA520).withValues(alpha: 0.5)
                  : const Color(0xFF90A4AE).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                showHeads ? Icons.sports_cricket_rounded : Icons.local_fire_department_rounded,
                size: size * 0.3,
                color: showHeads ? const Color(0xFF8B6914) : const Color(0xFF546E7A),
              ),
              const SizedBox(height: 2),
              Text(
                showHeads ? 'HEADS' : 'TAILS',
                style: TextStyle(
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.w900,
                  color: showHeads ? const Color(0xFF8B6914) : const Color(0xFF546E7A),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
