import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'record_payment_screen.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          appBar: DetailAppBar(title: context.t('title_invoice')),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(invoice.id, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                    invoice.status == InvoiceStatus.paid ? StatusBadge.paid(context) : StatusBadge.notPaid(context),
                  ],
                ),
                Text(invoice.customerName, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                const SizedBox(height: 14),
                SectionCard(
                  child: Column(
                    children: [
                      KeyValueRow('Invoice date', fmtDate(invoice.invoiceDate)),
                      const Divider(height: 20),
                      KeyValueRow('Due date', fmtDate(invoice.dueDate)),
                    ],
                  ),
                ),
                if (invoice.lines.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const Text('Lines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  SectionCard(
                    child: Column(
                      children: [
                        for (int i = 0; i < invoice.lines.length; i++) ...[
                          if (i > 0) const Divider(height: 24),
                          _LineRow(line: invoice.lines[i]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    child: Column(
                      children: [
                        KeyValueRow('Untaxed', '${fmtMoney(invoice.untaxed)} JOD'),
                        const Divider(height: 20),
                        KeyValueRow('Tax', '${fmtMoney(invoice.tax)} JOD'),
                        const Divider(height: 24),
                        KeyValueRow('Total', '${fmtMoney(invoice.total)} JOD',
                            valueStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const Divider(height: 20),
                        KeyValueRow('Amount due', '${fmtMoney(invoice.due)} JOD',
                            valueStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.danger)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: invoice.status == InvoiceStatus.paid
                      ? null
                      : () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecordPaymentScreen(invoice: invoice))),
                  child: Text(context.t('record_payment')),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not available in preview')),
                  ),
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: Text(context.t('view_download_pdf')),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not available in preview')),
                  ),
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: Text(context.t('print_share')),
                ),
              ],
            ),
          ),
        );
      },
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
