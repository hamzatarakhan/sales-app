import 'package:flutter/material.dart';
import '../../app_scope.dart';
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
      appBar: const DetailAppBar(title: 'Record payment'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount due', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Text('${fmtMoney(widget.invoice.due)} JOD', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _MethodBtn(label: 'Cash', selected: _method == 'Cash', onTap: () => setState(() => _method = 'Cash'))),
                const SizedBox(width: 10),
                Expanded(child: _MethodBtn(label: 'Cheque', selected: _method == 'Cheque', onTap: () => setState(() => _method = 'Cheque'))),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Amount', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
              child: const Text('Save payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecorded(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: AppColors.doneBg, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: AppColors.doneFg, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Payment recorded', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('The invoice balance has been updated.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
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
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.primary, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
