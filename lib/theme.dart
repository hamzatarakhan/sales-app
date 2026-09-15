import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF3E7CB1);
  static const primarySoft = Color(0xFFA9C7E0);
  static const bg = Color(0xFFF5F6F8);
  static const bgDark = Color(0xFF1C1E22);
  static const card = Colors.white;
  static const cardDark = Color(0xFF26292E);

  static const planBg = Color(0xFFE1EDF7);
  static const planFg = Color(0xFF3E7CB1);
  static const doneBg = Color(0xFFE3F1E8);
  static const doneFg = Color(0xFF4C9271);
  static const notPaidBg = Color(0xFFFBF0DC);
  static const notPaidFg = Color(0xFFB68A4A);
  static const draftBg = Color(0xFFEAEBED);
  static const draftFg = Color(0xFF767A82);
  static const danger = Color(0xFFC96A62);

  static const divider = Color(0xFFE7E8EB);
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
        borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
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
        side: BorderSide(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      height: 68,
      indicatorColor: AppColors.primary.withOpacity(isDark ? 0.22 : 0.14),
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? AppColors.primary : (isDark ? Colors.white60 : const Color(0xFF9AA0A8)),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 24,
          color: selected ? AppColors.primary : (isDark ? Colors.white60 : const Color(0xFF9AA0A8)),
        );
      }),
    ),
    dividerColor: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider,
  );
}

BoxDecoration cardDecoration(BuildContext context, {Color? color}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: color ?? (isDark ? AppColors.cardDark : AppColors.card),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
  );
}

Border softBorder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider);
}
