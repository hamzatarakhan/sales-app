import 'dart:async';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;
  Timer? _timer;

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
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
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
                      child: const Icon(Icons.check, color: Color(0xFF1565C0), size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sales Rep',
              style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const Spacer(flex: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      'Loading ${(_progress.clamp(0, 1) * 100).toStringAsFixed(2)}%',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
