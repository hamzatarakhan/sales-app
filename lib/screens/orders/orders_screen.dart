import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../models.dart';
import '../../widgets/common.dart';
import 'order_detail_screen.dart';

enum _Filter { all, draft, invoiced }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _Filter _filter = _Filter.all;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    var orders = state.orders.where((o) {
      final q = _search.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return o.id.toLowerCase().contains(q) || o.customerName.toLowerCase().contains(q);
    }).toList();
    if (_filter == _Filter.draft) orders = orders.where((o) => o.status == OrderStatus.draft).toList();
    if (_filter == _Filter.invoiced) orders = orders.where((o) => o.status == OrderStatus.invoiced).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'Reference or customer', prefixIcon: Icon(Icons.search)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _FilterChip(label: 'All', selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                _FilterChip(label: 'Draft', selected: _filter == _Filter.draft, onTap: () => setState(() => _filter = _Filter.draft)),
                _FilterChip(label: 'Invoiced', selected: _filter == _Filter.invoiced, onTap: () => setState(() => _filter = _Filter.invoiced)),
              ],
            ),
            const SizedBox(height: 12),
            for (final o in orders) ...[
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: o))),
                child: SectionCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.id, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('${o.customerName} · ${fmtDate(o.date)}', style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${fmtMoney(o.total)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 6),
                          o.status == OrderStatus.invoiced ? StatusBadge.invoiced() : StatusBadge.draft(),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w700),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }
}
