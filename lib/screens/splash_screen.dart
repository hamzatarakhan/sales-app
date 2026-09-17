import 'package:flutter/material.dart';
import '../l10n.dart';
import '../theme.dart';
import '../widgets/brand_icon.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final _logoScale = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack));
  late final _logoFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
  late final _textFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.35, 0.8, curve: Curves.easeOut));
  late final _textSlide = Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(_textFade);

  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);
  late final _pulseScale = Tween(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  // A single smooth animation drives the progress bar instead of a 40ms
  // polling Timer -- ties to the Ticker so it's frame-synced, not stepped.
  late final _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
    ..forward();
  late final _progress = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOutCubic);

  @override
  void initState() {
    super.initState();
    _progressCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 450),
            pageBuilder: (_, __, ___) => const SignInScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _progressCtrl.dispose();
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
                    child: const BrandIcon(size: 120),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textFade,
              child: SlideTransition(
                position: _textSlide,
                child: Text(
                  context.t('app_name'),
                  style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ),
            ),
            const Spacer(flex: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: AnimatedBuilder(
                  animation: _progress,
                  builder: (context, _) => LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 4,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
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
