import 'package:flutter/material.dart';
import 'l10n.dart';
import 'theme.dart';
import 'screens/visits/visits_screen.dart';
import 'screens/van_stock/van_stock_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/invoices/invoices_screen.dart';
import 'screens/more/more_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _tabs = [
    VisitsScreen(),
    VanStockScreen(),
    OrdersScreen(),
    InvoicesScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.cardDark : AppColors.card;
    final border = isDark ? AppColors.dividerDark : AppColors.divider;

    // Each tab carries its own accent, per the design system's tab-bar spec.
    final destinations = [
      (
        outline: Icons.map_outlined, filled: Icons.map, label: context.t('nav_visits'),
        color: AppColors.primary,
      ),
      (
        outline: Icons.inventory_2_outlined, filled: Icons.inventory_2, label: context.t('nav_stock'),
        color: AppColors.special,
      ),
      (
        outline: Icons.shopping_cart_outlined, filled: Icons.shopping_cart, label: context.t('nav_orders'),
        color: AppColors.warning,
      ),
      (
        outline: Icons.description_outlined, filled: Icons.description, label: context.t('nav_invoices'),
        color: AppColors.success,
      ),
      (
        outline: Icons.more_horiz, filled: Icons.more_horiz, label: context.t('nav_more'),
        color: AppColors.info,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: card, border: Border(top: BorderSide(color: border))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 54,
            child: Row(
              children: [
                for (int i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _TabItem(
                      icon: i == _index ? destinations[i].filled : destinations[i].outline,
                      label: destinations[i].label,
                      color: destinations[i].color,
                      selected: i == _index,
                      onTap: () => setState(() => _index = i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? color : AppColors.textFaint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(12),
          hoverColor: color.withValues(alpha: 0.08),
          splashColor: color.withValues(alpha: 0.12),
          highlightColor: color.withValues(alpha: 0.1),
          // InkWell's hover/splash overlays already animate their
          // opacity in smoothly (Material's default ~200ms fade) --
          // no custom AnimatedContainer needed for this.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: 21),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(color: fg, fontSize: 10, fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
