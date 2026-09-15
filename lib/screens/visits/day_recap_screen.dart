import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../widgets/common.dart';

class DayRecapScreen extends StatelessWidget {
  const DayRecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: DetailAppBar(title: context.t('day_recap')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(context.t('day_recap_subtitle'), style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 18),
            Text(context.t('sales'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow(context.t('orders_confirmed'), '${state.ordersConfirmedToday}'),
                  const Divider(height: 20),
                  KeyValueRow(context.t('total_sales'), '${fmtMoney(state.totalSalesToday)} JOD'),
                  const Divider(height: 20),
                  KeyValueRow(context.t('returns'), '0'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(context.t('nav_visits'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow(context.t('visits_done'), '${state.visitsDoneToday}'),
                  const Divider(height: 20),
                  KeyValueRow(context.t('resulted_in_order'), '${state.visitsWithOrderToday}'),
                  const Divider(height: 20),
                  KeyValueRow(context.t('no_purchase'), '${state.visitsNoPurchaseToday}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
