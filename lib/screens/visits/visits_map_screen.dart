import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class VisitsMapScreen extends StatefulWidget {
  const VisitsMapScreen({super.key});

  @override
  State<VisitsMapScreen> createState() => _VisitsMapScreenState();
}

class _VisitsMapScreenState extends State<VisitsMapScreen> {
  bool _located = false;
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final visits = state.visits;
    final done = visits.where((v) => v.status == VisitStatus.done).length;

    return Scaffold(
      appBar: DetailAppBar(title: context.t('visits_map')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SectionCard(
                child: Row(
                  children: [
                    Expanded(child: _Stat(value: '${visits.length}', label: context.t('stops'))),
                    Expanded(child: _Stat(value: '$done/${visits.length}', label: context.t('status_done'), color: AppColors.success)),
                    Expanded(child: _Stat(value: '6.8', label: context.t('km_route'))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.t('ordered_from_location'),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _located = true),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _MapPainter(visits: visits, located: _located),
                  child: Stack(
                    children: [
                      if (_located) const _MeLabel(),
                      for (int i = 0; i < visits.length; i++)
                        _PinButton(
                          index: i,
                          total: visits.length,
                          visit: visits[i],
                          selected: _selected == i,
                          onTap: () => setState(() => _selected = _selected == i ? null : i),
                          onLabelTap: () => _openInMaps(context, visits[i]),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openInMaps(BuildContext context, Visit v) {
    showAppBottomSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t('open_in_maps'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _MapsOption(icon: Icons.map, label: 'Apple Maps', onTap: () => Navigator.pop(ctx)),
            const SizedBox(height: 10),
            _MapsOption(icon: Icons.navigation, label: 'Google Maps', onTap: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.color});
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

class _MapsOption extends StatelessWidget {
  const _MapsOption({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SectionCard(
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _PinButton extends StatelessWidget {
  const _PinButton({
    required this.index,
    required this.total,
    required this.visit,
    required this.selected,
    required this.onTap,
    required this.onLabelTap,
  });
  final int index;
  final int total;
  final Visit visit;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLabelTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final pos = _pinPosition(index, total, constraints.biggest);
      final done = visit.status == VisitStatus.done;
      return Positioned(
        left: pos.dx - 16,
        top: pos.dy - 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (selected)
              GestureDetector(
                onTap: onLabelTap,
                child: _MapLabel(
                  title: '${index + 1}. ${visit.customerName}',
                  subtitle: '${visit.scheduledTime} · ${done ? context.t('status_done') : context.t('status_planned')}',
                ),
              ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done ? AppColors.success : AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _MeLabel extends StatelessWidget {
  const _MeLabel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final me = Offset(constraints.biggest.width * 0.1, constraints.biggest.height * 0.12);
      return Positioned(
        left: me.dx - 40,
        top: me.dy - 46,
        child: _MapLabel(title: context.t('you_are_here')),
      );
    });
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black87)),
          if (subtitle != null)
            Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        ],
      ),
    );
  }
}

Offset _pinPosition(int index, int total, Size size) {
  final dx = size.width * (0.25 + (0.5 * index / (total <= 1 ? 1 : total - 1)));
  final dy = size.height * (0.35 + (0.3 * index / (total <= 1 ? 1 : total - 1)));
  return Offset(dx, dy);
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.visits, required this.located});
  final List<Visit> visits;
  final bool located;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF23262B);
    canvas.drawRect(Offset.zero & size, bg);

    final roadPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x - 80, size.height), roadPaint);
    }
    for (double y = 40; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 30), roadPaint);
    }

    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final points = <Offset>[
      if (located) Offset(size.width * 0.1, size.height * 0.12),
      for (int i = 0; i < visits.length; i++) _pinPosition(i, visits.length, size),
    ];
    for (int i = 0; i < points.length - 1; i++) {
      _drawDashedLine(canvas, points[i], points[i + 1], routePaint);
    }

    if (located) {
      final me = Offset(size.width * 0.1, size.height * 0.12);
      canvas.drawCircle(me, 8, Paint()..color = Colors.white);
      canvas.drawCircle(me, 8, Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashLen = 10.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    double travelled = 0;
    while (travelled < total) {
      final start = a + dir * travelled;
      final end = a + dir * (travelled + dashLen).clamp(0, total).toDouble();
      canvas.drawLine(start, end, paint);
      travelled += dashLen * 2;
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.located != located;
}
