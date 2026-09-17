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
        icon: Directionality.of(context) == TextDirection.rtl ? Icons.chevron_right : Icons.chevron_left,
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

/// The visible chip is deliberately compact (28px), but the tappable
/// area is padded out to 40px — Material/iOS both call for a ~40-44px
/// minimum touch target, even when the visual element is smaller.
class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                shape: BoxShape.circle,
                // design-system.html #navigation: headers are flat with a
                // border, never a floating/shadowed element.
                border: Border.all(color: isDark ? AppColors.dividerDark : AppColors.divider),
              ),
              child: Icon(icon, size: 20, color: isDark ? Colors.white70 : AppColors.text),
            ),
          ),
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
      StatusBadge(text: context.t('status_planned'), bg: AppColors.infoTint, fg: AppColors.info);
  factory StatusBadge.done(BuildContext context) =>
      StatusBadge(text: context.t('status_done'), bg: AppColors.successTint, fg: AppColors.success);
  factory StatusBadge.invoiced(BuildContext context) =>
      StatusBadge(text: context.t('status_invoiced'), bg: AppColors.successTint, fg: AppColors.success);
  factory StatusBadge.draft(BuildContext context) =>
      StatusBadge(text: context.t('status_draft'), bg: AppColors.cardAlt, fg: AppColors.textMuted);
  factory StatusBadge.notPaid(BuildContext context) =>
      StatusBadge(text: context.t('status_not_paid'), bg: AppColors.warningTint, fg: AppColors.warning);
  factory StatusBadge.paid(BuildContext context) =>
      StatusBadge(text: context.t('status_paid'), bg: AppColors.successTint, fg: AppColors.success);

  @override
  Widget build(BuildContext context) {
    // design-system.html .m-badge: 3px/8-10px padding, radii.sm (8px),
    // weight 600 -- not the 20px pill this used to be.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12)),
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
      padding: padding ?? const EdgeInsets.all(14),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          trailing ??
              Text(value, style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
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
    final border = isDark ? AppColors.dividerDark : AppColors.divider;
    // Unselected fill is surface-alt, not surface (card) -- against a
    // white card and a near-white page background, a white chip read
    // as invisible until you noticed the 1px border. surface-alt gives
    // it real presence while staying a real design-system token.
    final unselectedBg = isDark ? AppColors.cardAltDark : AppColors.cardAlt;
    // design-system.html .m-chip, applied literally: padding: 8px 16px;
    // border-radius: 999px; font-size: 13px; font-weight: 600; border:
    // 1px solid var(--border); background: var(--surface-alt); color:
    // var(--text-muted) — and only .active swaps to solid accent fill.
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      // design-system.html .m-chip: padding 8px 16px, weight 600.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: selected ? AppColors.onPrimary : (isDark ? Colors.white70 : AppColors.textMuted),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      backgroundColor: unselectedBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: selected ? AppColors.primary : border),
    );
  }
}

/// Shows a bottom sheet with the app's standard chrome: a top-right ✕
/// close button (the design system's Sheet component), no Material drop
/// shadow (soft border instead), and automatic padding for the keyboard
/// and the bottom safe area.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool showCloseButton = true,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: isDark ? AppColors.cardDark : AppColors.card,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      side: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.divider),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCloseButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: isDark ? AppColors.textFaint : AppColors.textFaint, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            )
          else
            const SizedBox(height: 8),
          Flexible(child: builder(ctx)),
        ],
      ),
    ),
  );
}

String fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String fmtMoney(double v) => v.toStringAsFixed(2);
