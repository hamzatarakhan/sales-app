import 'package:flutter/material.dart';
import 'app_scope.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SalesRepApp());
}

class SalesRepApp extends StatefulWidget {
  const SalesRepApp({super.key});

  @override
  State<SalesRepApp> createState() => _SalesRepAppState();
}

class _SalesRepAppState extends State<SalesRepApp> {
  final _state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _state,
      child: AnimatedBuilder(
        animation: _state,
        builder: (context, _) {
          return MaterialApp(
            title: 'Sales Rep',
            debugShowCheckedModeBanner: false,
            themeMode: _state.themeMode,
            theme: buildTheme(Brightness.light),
            darkTheme: buildTheme(Brightness.dark),
            builder: (context, child) => Directionality(
              textDirection: _state.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
