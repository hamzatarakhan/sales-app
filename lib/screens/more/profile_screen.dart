import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: const DetailAppBar(title: 'Profile'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SectionCard(
              child: Column(
                children: [
                  KeyValueRow('Name', state.userName),
                  const Divider(height: 20),
                  KeyValueRow('Username', state.userUsername),
                  const Divider(height: 20),
                  KeyValueRow('Email', state.userEmail),
                  const Divider(height: 20),
                  KeyValueRow('Phone', state.userPhone),
                  const Divider(height: 20),
                  KeyValueRow('Company', state.userCompany),
                  const Divider(height: 20),
                  KeyValueRow('Vehicle', state.userVehicle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
