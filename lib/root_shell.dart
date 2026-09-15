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
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.divider)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.map_outlined), label: context.t('nav_visits')),
            NavigationDestination(icon: const Icon(Icons.inventory_2_outlined), label: context.t('nav_stock')),
            NavigationDestination(icon: const Icon(Icons.shopping_cart_outlined), label: context.t('nav_orders')),
            NavigationDestination(icon: const Icon(Icons.description_outlined), label: context.t('nav_invoices')),
            NavigationDestination(icon: const Icon(Icons.more_horiz), label: context.t('nav_more')),
          ],
        ),
      ),
    );
  }
}
