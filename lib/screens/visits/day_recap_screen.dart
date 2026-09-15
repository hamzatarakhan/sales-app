import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../widgets/common.dart';

class DayRecapScreen extends StatelessWidget {
  const DayRecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: const DetailAppBar(title: 'Day recap'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text("Today's activity, for end-of-shift reconciliation.", style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 18),
            const Text('Sales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow('Orders confirmed', '${state.ordersConfirmedToday}'),
                  const Divider(height: 20),
                  KeyValueRow('Total sales', '${fmtMoney(state.totalSalesToday)} JOD'),
                  const Divider(height: 20),
                  const KeyValueRow('Returns', '0'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Visits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow('Visits done', '${state.visitsDoneToday}'),
                  const Divider(height: 20),
                  KeyValueRow('Resulted in an order', '${state.visitsWithOrderToday}'),
                  const Divider(height: 20),
                  KeyValueRow('No purchase', '${state.visitsNoPurchaseToday}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
