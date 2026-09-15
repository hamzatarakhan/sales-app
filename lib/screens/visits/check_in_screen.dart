import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key, required this.visit});
  final Visit visit;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int? _distanceM;
  bool _photo = false;
  bool _locating = false;

  // ponytail: distance is simulated, not read from the OS. Wire up the
  // `geolocator` package (and location permissions) for a real GPS fix.
  Future<void> _getLocation() async {
    setState(() => _locating = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _locating = false;
      _distanceM = 4611;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: const DetailAppBar(title: 'Check in'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              "Confirms you're at the customer's location using your phone's GPS.",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            SectionCard(
              child: Column(
                children: [
                  if (_distanceM == null) ...[
                    Text('Not located yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ] else ...[
                    Text(
                      '${_distanceM}m away',
                      style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _locating ? null : _getLocation,
                    style: OutlinedButton.styleFrom(minimumSize: const Size(180, 44)),
                    child: _locating
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Get my location'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Merchandising photo (optional)', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  if (_photo)
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: Icon(Icons.check_circle, color: Colors.grey.shade600, size: 32),
                    )
                  else
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _photo = true),
                        style: OutlinedButton.styleFrom(minimumSize: const Size(160, 44)),
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text('Take photo'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _distanceM == null
                  ? null
                  : () {
                      state.checkIn(widget.visit, _distanceM!, photo: _photo);
                      _showSaved(context);
                    },
              child: const Text('Save check-in'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaved(BuildContext context) {
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
              decoration: BoxDecoration(color: AppColors.doneBg, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: AppColors.doneFg, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Check-in saved', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              _distanceM! > 100
                  ? "Saved — but you're ${_distanceM}m from the customer's known location."
                  : 'Saved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
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
