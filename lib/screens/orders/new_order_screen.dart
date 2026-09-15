import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../app_state.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/signature_pad.dart';
import '../invoices/invoice_detail_screen.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key, required this.visit});
  final Visit visit;

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final Map<String, int> _qty = {};
  final Map<String, int> _discount = {};

  double get _total {
    final state = AppStateScope.of(context);
    double t = 0;
    for (final p in state.products) {
      final q = _qty[p.sku] ?? 0;
      if (q > 0) {
        final d = _discount[p.sku] ?? 0;
        t += p.price * (1 - d / 100) * q;
      }
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final hasItems = _qty.values.any((q) => q > 0);

    return Scaffold(
      appBar: DetailAppBar(title: context.t('title_new_order')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                children: [
                  Text('Order for ${widget.visit.customerName}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  SectionCard(
                    child: Text('Balance ${widget.visit.balance.toStringAsFixed(0)} / limit ${widget.visit.creditLimit.toStringAsFixed(0)}'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(decoration: InputDecoration(hintText: context.t('name_or_reference'))),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: cardDecoration(context),
                        child: const Icon(Icons.qr_code_scanner_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (final p in state.products) ...[
                    _ProductRow(
                      product: p,
                      qty: _qty[p.sku] ?? 0,
                      discount: _discount[p.sku] ?? 0,
                      onQty: (q) => setState(() => _qty[p.sku] = q),
                      onDiscount: (d) => setState(() => _discount[p.sku] = d),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton(
                onPressed: hasItems ? () => _confirm(context, state) : null,
                child: Text(hasItems ? '${context.t('confirm_order')} · ${fmtMoney(_total)} JOD' : context.t('confirm_order')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context, AppState state) {
    final lines = <OrderLine>[
      for (final p in state.products)
        if ((_qty[p.sku] ?? 0) > 0)
          OrderLine(product: p, qty: _qty[p.sku]!, discountPercent: _discount[p.sku] ?? 0),
    ];
    final order = state.confirmOrder(widget.visit, lines);
    _showSignatureSheet(context, state, order);
  }

  void _showSignatureSheet(BuildContext context, AppState state, SalesOrder order) {
    final key = GlobalKey<SignaturePadState>();
    bool hasSig = false;
    showAppBottomSheet(
      context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.t('customer_signature'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text("Have the customer sign to confirm this order before it's finalized.",
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 16),
              SignaturePad(key: key, onChanged: (v) => setSheetState(() => hasSig = v)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        key.currentState?.clear();
                        setSheetState(() => hasSig = false);
                      },
                      child: Text(context.t('clear')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: hasSig
                          ? () {
                              Navigator.pop(ctx);
                              final invoice = state.signAndInvoice(order);
                              _showConfirmed(context, invoice);
                            }
                          : null,
                      child: Text(context.t('save_signature')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmed(BuildContext context, Invoice invoice) {
    showAppBottomSheet(
      context,
      isDismissible: false,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: AppColors.successTint, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: AppColors.success, size: 32),
            ),
            const SizedBox(height: 16),
            Text(context.t('order_confirmed'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Van stock was deducted and the invoice was created.',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('Invoice: ${invoice.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: invoice)));
                },
                child: Text(context.t('view_invoice')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.qty,
    required this.discount,
    required this.onQty,
    required this.onDiscount,
  });
  final Product product;
  final int qty;
  final int discount;
  final ValueChanged<int> onQty;
  final ValueChanged<int> onDiscount;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: '${fmtMoney(product.price)} JOD · ', style: TextStyle(color: Colors.grey.shade600)),
                      TextSpan(
                        text: product.isOut
                            ? 'Out of stock'
                            : '${product.vanStock} Case in van${product.isLow ? ' (low)' : ''}',
                        style: TextStyle(
                          color: (product.isLow || product.isOut) ? AppColors.danger : Colors.grey.shade600,
                          fontWeight: (product.isLow || product.isOut) ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ])),
                  ],
                ),
              ),
              _Stepper(qty: qty, onChanged: onQty, max: product.vanStock),
            ],
          ),
          if (qty > 0) ...[
            const Divider(height: 24),
            Row(
              children: [
                Text('Discount', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(width: 10),
                Wrap(
                  spacing: 6,
                  children: [0, 5, 10, 15, 20].map((d) {
                    return AppChip(label: '$d%', selected: d == discount, onTap: () => onDiscount(d));
                  }).toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.qty, required this.onChanged, required this.max});
  final int qty;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepBtn(icon: Icons.remove, onTap: qty > 0 ? () => onChanged(qty - 1) : null),
        SizedBox(width: 32, child: Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
        _StepBtn(icon: Icons.add, onTap: qty < max ? () => onChanged(qty + 1) : null),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: onTap == null ? Colors.grey.shade400 : Colors.black87),
      ),
    );
  }
}
