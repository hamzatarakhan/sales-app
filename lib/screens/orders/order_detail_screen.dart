import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../widgets/common.dart';
import '../invoices/invoice_detail_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});
  final SalesOrder order;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: DetailAppBar(title: context.t('title_order')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(order.id, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                order.status == OrderStatus.invoiced ? StatusBadge.invoiced(context) : StatusBadge.draft(context),
              ],
            ),
            Text(order.customerName, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow('Date', fmtDate(order.date)),
                  if (order.hasSignature) ...[
                    const Divider(height: 20),
                    KeyValueRow(
                      'Customer signature',
                      'Captured',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Captured', style: TextStyle(color: Color(0xFF1F9254), fontWeight: FontWeight.w700)),
                          SizedBox(width: 4),
                          Icon(Icons.check, color: Color(0xFF1F9254), size: 18),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (order.lines.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Text('Lines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              SectionCard(
                child: Column(
                  children: [
                    for (int i = 0; i < order.lines.length; i++) ...[
                      if (i > 0) const Divider(height: 24),
                      _LineRow(line: order.lines[i]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(child: KeyValueRow('Total', '${fmtMoney(order.total)} JOD')),
            ],
            const SizedBox(height: 24),
            if (order.status == OrderStatus.invoiced) ...[
              ElevatedButton(
                onPressed: () {
                  final inv = state.invoices.firstWhere(
                    (i) => i.id == order.invoiceId,
                    orElse: () => state.invoices.first,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: inv)));
                },
                child: Text(context.t('view_invoice')),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not available in preview')),
                ),
                child: Text(context.t('create_return')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line});
  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line.product.name),
              Text('${fmtMoney(line.unitPrice)} JOD', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        Text('${line.qty} x ${line.unitPrice.toStringAsFixed(line.unitPrice.truncateToDouble() == line.unitPrice ? 0 : 1)}',
            style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
