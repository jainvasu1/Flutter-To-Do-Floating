import 'dart:async';

import 'package:flutter/material.dart';

/// Plays the animated splash GIF once, then replaces itself with [next].
/// Tapping anywhere skips straight to [next].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.next});

  static const Color background = Color(0xFFFCFCFF);
  static const String gifPath = 'assets/images/splash.gif';

  /// Length of one full play of splash.gif.
  static const Duration duration = Duration(seconds: 6);

  final Widget next;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(SplashScreen.duration, _goNext);
  }

  void _goNext() {
    if (_done || !mounted) return;
    _done = true;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => widget.next,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _goNext,
      child: const ColoredBox(
        color: SplashScreen.background,
        child: SizedBox.expand(
          child: Image(
            image: AssetImage(SplashScreen.gifPath),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}
