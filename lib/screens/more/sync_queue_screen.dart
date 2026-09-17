import 'package:flutter/material.dart';
import '../../l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(title: context.t('sync_queue')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.t('online'), style: TextStyle(color: AppTones.success(context), fontWeight: FontWeight.w700)),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textFaint),
                    const SizedBox(height: 12),
                    Text(context.t('nothing_queued'), style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
