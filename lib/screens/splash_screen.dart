import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _progress = 0;
  Timer? _timer;

  late final _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final _logoScale = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack));
  late final _logoFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
  late final _textFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.35, 0.8, curve: Curves.easeOut));
  late final _textSlide = Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(_textFade);

  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);
  late final _pulseScale = Tween(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      setState(() => _progress += 0.028);
      if (_progress >= 1) {
        t.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 4),
            AnimatedBuilder(
              animation: Listenable.merge([_entrance, _pulse]),
              builder: (context, _) {
                return Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(
                    scale: _logoScale.value * _pulseScale.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 64),
                          Positioned(
                            top: 30,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Icons.check, color: AppColors.primary, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textFade,
              child: SlideTransition(
                position: _textSlide,
                child: const Text(
                  'Sales Rep',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
            ),
            const Spacer(flex: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: _progress.clamp(0, 1),
                  minHeight: 4,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
