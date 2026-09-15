import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'check_in_screen.dart';
import '../orders/new_order_screen.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({super.key, required this.visit});
  final Visit visit;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          appBar: const DetailAppBar(title: 'Visit'),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(visit.customerName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    ),
                    visit.status == VisitStatus.done ? StatusBadge.done(context) : StatusBadge.planned(context),
                  ],
                ),
                const SizedBox(height: 14),
                SectionCard(
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(visit.address, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(visit.city, style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Icon(Icons.navigation_outlined, color: Colors.grey.shade400),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Column(
                    children: [
                      KeyValueRow('Scheduled', visit.scheduledTime),
                      const Divider(height: 20),
                      KeyValueRow(
                        'Phone',
                        visit.phone,
                        valueStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: KeyValueRow('Balance / credit limit', '${visit.balance.toStringAsFixed(0)} / ${visit.creditLimit.toStringAsFixed(0)} JOD'),
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckInScreen(visit: visit))),
                  child: SectionCard(
                    child: Row(
                      children: [
                        const Icon(Icons.near_me_outlined, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.t('check_in'), style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(
                                visit.checkedIn ? '${visit.checkInDistanceM}m away' : context.t('not_checked_in'),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
                if (!visit.checkedIn) ...[
                  const SizedBox(height: 10),
                  Text(
                    context.t('check_in_unlock'),
                    style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600),
                  ),
                ],
                if (visit.checkedIn && visit.hasMerchPhoto) ...[
                  const SizedBox(height: 12),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Merchandising photo', style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 10),
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: visit.checkedIn && visit.status != VisitStatus.done
                      ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewOrderScreen(visit: visit)))
                      : null,
                  child: Text(context.t('start_new_order')),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: visit.checkedIn && visit.status != VisitStatus.done
                        ? () {
                            state.markNoPurchase(visit);
                            Navigator.of(context).maybePop();
                          }
                        : null,
                    child: Text(context.t('no_purchase'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
