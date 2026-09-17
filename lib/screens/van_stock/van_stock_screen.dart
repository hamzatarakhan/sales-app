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
                  decoration: InputDecoration(hintText: context.t('name_or_reference'), prefixIcon: const Icon(Icons.search, size: 18)),
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
                if (products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 26, color: AppColors.textFaint),
                        const SizedBox(height: 8),
                        Text(context.t('no_products_found'), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  ),
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
                                Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                Text(p.sku, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${p.vanStock}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: p.isOut ? AppTones.danger(context) : (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.text))),
                              Text(context.t('case_unit'), style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
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
      },
    );
  }
}
