import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class RecordPaymentScreen extends StatefulWidget {
  const RecordPaymentScreen({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  String _method = 'Cash';
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: fmtMoney(widget.invoice.due));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final amount = double.tryParse(_amount.text) ?? 0;
    return Scaffold(
      appBar: DetailAppBar(title: context.t('record_payment')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.t('amount_due'), style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Text('${fmtMoney(widget.invoice.due)} JOD', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(context.t('payment_method'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _MethodBtn(label: context.t('cash'), selected: _method == 'Cash', onTap: () => setState(() => _method = 'Cash'))),
                const SizedBox(width: 10),
                Expanded(child: _MethodBtn(label: context.t('cheque'), selected: _method == 'Cheque', onTap: () => setState(() => _method = 'Cheque'))),
              ],
            ),
            const SizedBox(height: 18),
            Text(context.t('amount'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 10),
            TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: amount > 0
                  ? () {
                      state.recordPayment(widget.invoice, amount);
                      _showRecorded(context);
                    }
                  : null,
              child: Text(context.t('save_payment')),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecorded(BuildContext context) {
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
              decoration: BoxDecoration(color: AppTones.successTint(ctx), shape: BoxShape.circle),
              child: Icon(Icons.check, color: AppTones.success(ctx), size: 32),
            ),
            const SizedBox(height: 16),
            Text(context.t('payment_recorded'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(context.t('invoice_balance_updated'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pop();
                },
                child: Text(context.t('done')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodBtn extends StatelessWidget {
  const _MethodBtn({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.primary, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
