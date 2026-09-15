import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'invoice_detail_screen.dart';

enum _Filter { all, open, overdue, paid }

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  _Filter _filter = _Filter.open;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final now = DateTime.now();
    var invoices = state.invoices.where((i) {
      final q = _search.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return i.id.toLowerCase().contains(q) || i.customerName.toLowerCase().contains(q);
    }).toList();

    switch (_filter) {
      case _Filter.all:
        break;
      case _Filter.open:
        invoices = invoices.where((i) => i.status == InvoiceStatus.notPaid).toList();
        break;
      case _Filter.overdue:
        invoices = invoices.where((i) => i.status == InvoiceStatus.notPaid && i.dueDate.isBefore(now)).toList();
        break;
      case _Filter.paid:
        invoices = invoices.where((i) => i.status == InvoiceStatus.paid).toList();
        break;
    }

    final outstanding = invoices.where((i) => i.status == InvoiceStatus.notPaid).fold(0.0, (s, i) => s + i.due);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('nav_invoices'))),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: context.t('number_or_customer'), prefixIcon: const Icon(Icons.search)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                AppChip(label: context.t('filter_all'), selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                AppChip(label: context.t('open'), selected: _filter == _Filter.open, onTap: () => setState(() => _filter = _Filter.open)),
                AppChip(label: context.t('overdue'), selected: _filter == _Filter.overdue, onTap: () => setState(() => _filter = _Filter.overdue)),
                AppChip(label: context.t('status_paid'), selected: _filter == _Filter.paid, onTap: () => setState(() => _filter = _Filter.paid)),
              ],
            ),
            const SizedBox(height: 12),
            SectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${invoices.length} invoices · outstanding', style: TextStyle(color: Colors.grey.shade600)),
                  Text('${fmtMoney(outstanding)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final inv in invoices) ...[
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: inv))),
                child: SectionCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inv.id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(inv.customerName, style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${fmtMoney(inv.total)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          Text(
                            'due ${fmtDate(inv.dueDate)}',
                            style: TextStyle(
                              color: inv.status == InvoiceStatus.notPaid && inv.dueDate.isBefore(now)
                                  ? AppColors.danger
                                  : Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          inv.status == InvoiceStatus.paid ? StatusBadge.paid(context) : StatusBadge.notPaid(context),
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
