import 'package:flutter/material.dart';
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
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Visits'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Van stock'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Invoices'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
