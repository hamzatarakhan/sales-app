import 'package:flutter/material.dart';

/// Tokens copied verbatim from distributor-app's design-system.html —
/// same family, same app. Light values are the ones actually used as
/// constants app-wide (the app defaults to light theme); buildTheme()
/// additionally swaps in the dark-tuned background/card/border/text
/// tokens for dark mode.
class AppColors {
  // Brand
  static const primary = Color(0xFF0A6EBD);
  static const primaryTint = Color(0x1A0A6EBD);
  static const primaryBorder = Color(0x380A6EBD);
  static const onPrimary = Color(0xFFFFFFFF);

  // Light surfaces
  static const bg = Color(0xFFF6F7F9);
  static const card = Color(0xFFFFFFFF);
  static const cardAlt = Color(0xFFF1F3F5);
  static const divider = Color(0xFFE3E6EA);
  static const text = Color(0xFF11181C);
  static const textMuted = Color(0xFF5B636B);
  static const textFaint = Color(0xFF8A929A);

  // Dark surfaces
  static const bgDark = Color(0xFF0E1113);
  static const cardDark = Color(0xFF181C1F);
  static const cardAltDark = Color(0xFF20262A);
  static const dividerDark = Color(0xFF2A3136);

  // Tone vocabulary — success/warning/danger/info/special, each with a tint
  static const success = Color(0xFF0F9D58);
  static const successTint = Color(0x1F0F9D58);
  static const warning = Color(0xFFE8A100);
  static const warningTint = Color(0x24E8A100);
  static const danger = Color(0xFFD7263D);
  static const dangerTint = Color(0x1FD7263D);
  static const info = Color(0xFF2F80ED);
  static const infoTint = Color(0x1F2F80ED);
  static const special = Color(0xFF8B5CF6);
  static const specialTint = Color(0x1F8B5CF6);

  static const overlay = Color(0x73000000);

  // Kept for source clarity where a status badge's tone is picked by name
  // (see StatusBadge factories in widgets/common.dart) rather than tone.
  static const primarySoft = Color(0xFFA9C7E0);
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final bg = isDark ? AppColors.bgDark : AppColors.bg;
  final card = isDark ? AppColors.cardDark : AppColors.card;
  final border = isDark ? AppColors.dividerDark : AppColors.divider;
  return ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
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
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: isDark ? Colors.white : Colors.black,
      toolbarHeight: 52,
      titleTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black,
      ),
      shape: Border(bottom: BorderSide(color: border)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primarySoft,
        disabledForegroundColor: AppColors.onPrimary,
        minimumSize: const Size.fromHeight(46),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(46),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    dividerColor: border,
    // Material 3's Divider widget reads DividerThemeData, not
    // ThemeData.dividerColor above — without this it falls back to
    // colorScheme.outlineVariant (a blue-tinted grey derived from the
    // seed color) instead of the design system's flat border token.
    dividerTheme: DividerThemeData(color: border, space: 1, thickness: 1),
  );
}

BoxDecoration cardDecoration(BuildContext context, {Color? color}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: color ?? (isDark ? AppColors.cardDark : AppColors.card),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: isDark ? AppColors.dividerDark : AppColors.divider),
  );
}

Border softBorder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Border.all(color: isDark ? AppColors.dividerDark : AppColors.divider);
}
