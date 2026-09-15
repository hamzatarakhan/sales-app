import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'visit_detail_screen.dart';
import 'visits_map_screen.dart';
import 'day_recap_screen.dart';
import '../more/sync_queue_screen.dart';

enum _Filter { all, remaining, done }

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  _Filter _filter = _Filter.all;

  static const _weekday = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _month = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final visits = state.visits;
    final remaining = visits.where((v) => v.status == VisitStatus.planned).length;
    final done = visits.where((v) => v.status == VisitStatus.done).length;

    List<Visit> shown;
    String filterLabel;
    switch (_filter) {
      case _Filter.all:
        shown = visits;
        filterLabel = context.t('filter_all');
        break;
      case _Filter.remaining:
        shown = visits.where((v) => v.status == VisitStatus.planned).toList();
        filterLabel = context.t('filter_remaining');
        break;
      case _Filter.done:
        shown = visits.where((v) => v.status == VisitStatus.done).toList();
        filterLabel = context.t('filter_done');
        break;
    }

    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t('greeting', [state.userName.split(' ').first]),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${_weekday[now.weekday - 1]}, ${_month[now.month - 1]} ${now.day}',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: AppColors.primaryTint, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_none, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SectionCard(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.calendar_today_outlined,
                      value: '${visits.length}',
                      label: context.t('filter_all'),
                      selected: _filter == _Filter.all,
                      color: AppColors.primary,
                      onTap: () => setState(() => _filter = _Filter.all),
                    ),
                  ),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.access_time,
                      value: '$remaining',
                      label: context.t('filter_remaining'),
                      selected: _filter == _Filter.remaining,
                      color: const Color(0xFFB07D12),
                      onTap: () => setState(() => _filter = _Filter.remaining),
                    ),
                  ),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.check_circle_outline,
                      value: '$done',
                      label: context.t('filter_done'),
                      selected: _filter == _Filter.done,
                      color: AppColors.success,
                      onTap: () => setState(() => _filter = _Filter.done),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(context.t('quick_tools'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickTool(
                    icon: Icons.bar_chart,
                    iconBg: AppColors.specialTint,
                    iconColor: AppColors.special,
                    label: context.t('day_recap'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DayRecapScreen())),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickTool(
                    icon: Icons.map_outlined,
                    iconBg: AppColors.successTint,
                    iconColor: AppColors.success,
                    label: context.t('visits_map'),
                    badge: remaining > 0 ? '$remaining' : null,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VisitsMapScreen())),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickTool(
                    icon: Icons.cloud_upload_outlined,
                    iconBg: AppColors.primaryTint,
                    iconColor: AppColors.primary,
                    label: context.t('sync_queue'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncQueueScreen())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text('${context.t('today_visits')} · $filterLabel', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            for (final v in shown) ...[
              _VisitCard(visit: v),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String value;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.infoTint : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _QuickTool extends StatelessWidget {
  const _QuickTool({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.badge,
  });
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: cardDecoration(context),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor),
                ),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(badge!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.visit});
  final Visit visit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VisitDetailScreen(visit: visit))),
      child: SectionCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(visit.customerName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${visit.scheduledTime} · ${visit.city}', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            visit.status == VisitStatus.done ? StatusBadge.done(context) : StatusBadge.planned(context),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
