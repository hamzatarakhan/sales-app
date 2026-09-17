import 'package:flutter/material.dart';
import '../l10n.dart';
import '../widgets/brand_icon.dart';
import 'sign_in_screen.dart';

/// Full-bleed brand splash: the icon's own blue bleeds into the screen
/// via a radial gradient (instead of a small icon floating on plain
/// white), with a soft glow, a gentle breathing pulse, and a ring that
/// draws itself in around the icon -- built directly off the brand mark
/// artwork rather than a generic logo-and-progress-bar layout.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
  late final _logoScale = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack));
  late final _logoFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.4, curve: Curves.easeOut));
  late final _ringSweep = CurvedAnimation(parent: _entrance, curve: const Interval(0.15, 0.75, curve: Curves.easeOutCubic));
  late final _textFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.45, 0.85, curve: Curves.easeOut));
  late final _textSlide = Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(_textFade);

  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
    ..repeat(reverse: true);
  late final _pulseScale = Tween(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  late final _glowPulse = Tween(begin: 0.55, end: 0.9).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  late final _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1900))
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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.15),
            radius: 1.15,
            colors: [Color(0xFF1E88E5), Color(0xFF0B4C91), Color(0xFF072F5F)],
            stops: [0.0, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 4),
              AnimatedBuilder(
                animation: Listenable.merge([_entrance, _pulse]),
                builder: (context, _) {
                  return SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ambient glow behind the icon -- echoes the neon
                        // ring in the artwork instead of a flat drop shadow.
                        Opacity(
                          opacity: _logoFade.value * _glowPulse.value,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.35),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // A ring that sweeps in around the icon, echoing
                        // the checkmark's own partial-circle motif.
                        Opacity(
                          opacity: _logoFade.value,
                          child: SizedBox(
                            width: 148,
                            height: 148,
                            child: CircularProgressIndicator(
                              value: _ringSweep.value,
                              strokeWidth: 2,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.5)),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _logoFade.value,
                          child: Transform.scale(
                            scale: _logoScale.value * _pulseScale.value,
                            child: const BrandIcon(size: 108),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      Text(
                        context.t('app_name'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: 0.2),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.t('sign_in_subtitle'),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 56),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) => LinearProgressIndicator(
                      value: _progress.value,
                      minHeight: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
