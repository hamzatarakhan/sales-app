import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1565C0);
  static const primarySoft = Color(0xFF6FA8DC);
  static const bg = Color(0xFFF3F4F6);
  static const bgDark = Color(0xFF17191C);
  static const card = Colors.white;
  static const cardDark = Color(0xFF23262B);

  static const planBg = Color(0xFFDCEBFC);
  static const planFg = Color(0xFF1565C0);
  static const doneBg = Color(0xFFDCF5E3);
  static const doneFg = Color(0xFF1F9254);
  static const notPaidBg = Color(0xFFFCEFD1);
  static const notPaidFg = Color(0xFFB07D12);
  static const draftBg = Color(0xFFE7E8EA);
  static const draftFg = Color(0xFF5B5F66);
  static const danger = Color(0xFFD3392E);
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final bg = isDark ? AppColors.bgDark : AppColors.bg;
  final card = isDark ? AppColors.cardDark : AppColors.card;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ),
    cardColor: card,
    cardTheme: CardTheme(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: isDark ? Colors.white : Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primarySoft,
        disabledForegroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark ? Colors.white54 : const Color(0xFF8A8F98),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 0,
    ),
    dividerColor: isDark ? Colors.white12 : Colors.black12,
  );
}

BoxDecoration cardDecoration(BuildContext context, {Color? color}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: color ?? (isDark ? AppColors.cardDark : AppColors.card),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
  );
}

Border softBorder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08));
}
