import 'package:flutter/material.dart';
import '../../app_scope.dart';
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
      appBar: AppBar(title: const Text('Invoices')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'Number or customer', prefixIcon: Icon(Icons.search)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _FilterChip(label: 'All', selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                _FilterChip(label: 'Open', selected: _filter == _Filter.open, onTap: () => setState(() => _filter = _Filter.open)),
                _FilterChip(label: 'Overdue', selected: _filter == _Filter.overdue, onTap: () => setState(() => _filter = _Filter.overdue)),
                _FilterChip(label: 'Paid', selected: _filter == _Filter.paid, onTap: () => setState(() => _filter = _Filter.paid)),
              ],
            ),
            const SizedBox(height: 12),
            SectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${invoices.length} invoices · outstanding', style: TextStyle(color: Colors.grey.shade600)),
                  Text('${fmtMoney(outstanding)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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
                            Text(inv.id, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(inv.customerName, style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${fmtMoney(inv.total)} JOD', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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
                          inv.status == InvoiceStatus.paid ? StatusBadge.paid() : StatusBadge.notPaid(),
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
