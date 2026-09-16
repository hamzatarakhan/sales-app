import 'package:flutter/material.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../widgets/common.dart';

class VanStockDetailScreen extends StatelessWidget {
  const VanStockDetailScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(title: context.t('title_van_stock')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(product.sku, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow(context.t('price'), '${fmtMoney(product.price)} JOD'),
                  const Divider(height: 20),
                  KeyValueRow(context.t('title_van_stock'), '${product.vanStock} ${context.t('case_unit')}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
