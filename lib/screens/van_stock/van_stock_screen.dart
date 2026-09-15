import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'van_stock_detail_screen.dart';

enum _Filter { all, low, out }

class VanStockScreen extends StatefulWidget {
  const VanStockScreen({super.key});

  @override
  State<VanStockScreen> createState() => _VanStockScreenState();
}

class _VanStockScreenState extends State<VanStockScreen> {
  _Filter _filter = _Filter.all;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        var products = state.products.where((p) {
          final q = _search.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q);
        }).toList();
        if (_filter == _Filter.low) products = products.where((p) => p.isLow).toList();
        if (_filter == _Filter.out) products = products.where((p) => p.isOut).toList();

        return Scaffold(
          appBar: AppBar(title: Text(context.t('title_van_stock'))),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(hintText: context.t('name_or_reference'), prefixIcon: const Icon(Icons.search)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    AppChip(label: context.t('filter_all'), selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                    AppChip(label: context.t('low_stock'), selected: _filter == _Filter.low, onTap: () => setState(() => _filter = _Filter.low)),
                    AppChip(label: context.t('out_of_stock'), selected: _filter == _Filter.out, onTap: () => setState(() => _filter = _Filter.out)),
                  ],
                ),
                const SizedBox(height: 12),
                for (final p in products) ...[
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VanStockDetailScreen(product: p))),
                    child: SectionCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                Text(p.sku, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${p.vanStock}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: p.isOut ? AppColors.danger : Colors.black87)),
                              Text(context.t('case_unit'), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
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
      },
    );
  }
}
