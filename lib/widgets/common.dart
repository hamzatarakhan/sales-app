import 'package:flutter/material.dart';
import '../l10n.dart';
import '../theme.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppBar({super.key, required this.title, this.actions});
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _RoundButton(
        icon: Icons.chevron_left,
        onTap: () => Navigator.of(context).maybePop(),
      ),
      title: Text(title),
      actions: [
        ...?actions,
        _RoundButton(
          icon: Icons.home_outlined,
          onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
          ),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;

  factory StatusBadge.planned(BuildContext context) =>
      StatusBadge(text: context.t('status_planned'), bg: AppColors.planBg, fg: AppColors.planFg);
  factory StatusBadge.done(BuildContext context) =>
      StatusBadge(text: context.t('status_done'), bg: AppColors.doneBg, fg: AppColors.doneFg);
  factory StatusBadge.invoiced(BuildContext context) =>
      StatusBadge(text: context.t('status_invoiced'), bg: AppColors.doneBg, fg: AppColors.doneFg);
  factory StatusBadge.draft(BuildContext context) =>
      StatusBadge(text: context.t('status_draft'), bg: AppColors.draftBg, fg: AppColors.draftFg);
  factory StatusBadge.notPaid(BuildContext context) =>
      StatusBadge(text: context.t('status_not_paid'), bg: AppColors.notPaidBg, fg: AppColors.notPaidFg);
  factory StatusBadge.paid(BuildContext context) =>
      StatusBadge(text: context.t('status_paid'), bg: AppColors.doneBg, fg: AppColors.doneFg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: cardDecoration(context),
      child: child,
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow(this.label, this.value, {super.key, this.valueStyle, this.trailing});
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
          trailing ??
              Text(value, style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      ),
    );
  }
}

/// A single filter/segment pill used across the app (van stock, orders,
/// invoices filters; appearance/language segments; discount picker) —
/// always the app's primary color when selected, never the Material3
/// seed-derived colorScheme.primary, and no checkmark clutter.
class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }
}

/// Shows a bottom sheet with the app's standard chrome: a drag handle,
/// no Material drop shadow (soft border instead), and automatic padding
/// for the keyboard and the bottom safe area.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool isScrollControlled = false,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: isDark ? AppColors.cardDark : AppColors.card,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      side: BorderSide(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(child: builder(ctx)),
        ],
      ),
    ),
  );
}

String fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String fmtMoney(double v) => v.toStringAsFixed(2);
