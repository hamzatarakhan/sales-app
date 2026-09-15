import 'package:flutter/material.dart';
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
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
            ],
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

  factory StatusBadge.planned() =>
      const StatusBadge(text: 'Planned', bg: AppColors.planBg, fg: AppColors.planFg);
  factory StatusBadge.done() =>
      const StatusBadge(text: 'Done', bg: AppColors.doneBg, fg: AppColors.doneFg);
  factory StatusBadge.invoiced() =>
      const StatusBadge(text: 'Invoiced', bg: AppColors.doneBg, fg: AppColors.doneFg);
  factory StatusBadge.draft() =>
      const StatusBadge(text: 'Draft', bg: AppColors.draftBg, fg: AppColors.draftFg);
  factory StatusBadge.notPaid() =>
      const StatusBadge(text: 'Not paid', bg: AppColors.notPaidBg, fg: AppColors.notPaidFg);
  factory StatusBadge.paid() =>
      const StatusBadge(text: 'Paid', bg: AppColors.doneBg, fg: AppColors.doneFg);

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

String fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String fmtMoney(double v) => v.toStringAsFixed(2);
