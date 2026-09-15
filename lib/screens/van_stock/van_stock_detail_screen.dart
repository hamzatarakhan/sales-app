import 'package:flutter/material.dart';
import '../../models.dart';
import '../../widgets/common.dart';

class VanStockDetailScreen extends StatelessWidget {
  const VanStockDetailScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailAppBar(title: 'Van stock'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(product.sku, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow('Price', '${fmtMoney(product.price)} JOD'),
                  const Divider(height: 20),
                  KeyValueRow('Van stock', '${product.vanStock} Case'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
