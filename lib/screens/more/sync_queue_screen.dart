import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailAppBar(title: 'Sync queue'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Online', style: TextStyle(color: AppColors.doneFg, fontWeight: FontWeight.w700)),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text('Nothing queued.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
