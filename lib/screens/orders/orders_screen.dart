import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
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
      appBar: AppBar(title: Text(context.t('nav_orders'))),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => Future.delayed(const Duration(milliseconds: 600)),
          child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: context.t('reference_or_customer'), prefixIcon: const Icon(Icons.search, size: 18)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                AppChip(label: context.t('filter_all'), selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                AppChip(label: context.t('status_draft'), selected: _filter == _Filter.draft, onTap: () => setState(() => _filter = _Filter.draft)),
                AppChip(label: context.t('status_invoiced'), selected: _filter == _Filter.invoiced, onTap: () => setState(() => _filter = _Filter.invoiced)),
              ],
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 26, color: AppColors.textFaint),
                    const SizedBox(height: 8),
                    Text(context.t('no_orders_found'), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
              ),
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
                            Text(o.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('${o.customerName} · ${fmtDate(o.date)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${fmtMoney(o.total)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                          const SizedBox(height: 6),
                          o.status == OrderStatus.invoiced ? StatusBadge.invoiced(context) : StatusBadge.draft(context),
                        ],
                      ),
                      Icon(Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left : Icons.chevron_right, color: AppColors.textFaint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
          ),
        ),
      ),
    );
  }
}
