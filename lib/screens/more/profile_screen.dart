import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../l10n.dart';
import '../../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: DetailAppBar(title: context.t('profile')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow(context.t('name'), state.userName),
                  const Divider(height: 20),
                  KeyValueRow(context.t('username'), state.userUsername),
                  const Divider(height: 20),
                  KeyValueRow(context.t('email'), state.userEmail),
                  const Divider(height: 20),
                  KeyValueRow(context.t('phone'), state.userPhone),
                  const Divider(height: 20),
                  KeyValueRow(context.t('company'), state.userCompany),
                  const Divider(height: 20),
                  KeyValueRow(context.t('vehicle'), state.userVehicle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
