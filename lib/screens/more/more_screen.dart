import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../app_state.dart';
import '../../l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../sign_in_screen.dart';
import 'profile_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(context.t('nav_more'))),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(state.userEmail, style: TextStyle(color: Colors.grey.shade600)),
                      Text(state.userCompany, style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.person_outline,
                  iconBg: AppColors.primaryTint,
                  iconColor: AppColors.primary,
                  title: context.t('profile'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const _IconBox(icon: Icons.contrast, bg: AppColors.specialTint, color: AppColors.special),
                          const SizedBox(width: 12),
                          Text(context.t('appearance'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Segmented(
                        options: {'System': context.t('system'), 'Light': context.t('light'), 'Dark': context.t('dark')},
                        selected: state.themeMode == ThemeMode.system
                            ? 'System'
                            : state.themeMode == ThemeMode.light
                                ? 'Light'
                                : 'Dark',
                        onSelect: (v) => state.setThemeMode(
                            v == 'System' ? ThemeMode.system : (v == 'Light' ? ThemeMode.light : ThemeMode.dark)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const _IconBox(icon: Icons.translate, bg: AppColors.specialTint, color: AppColors.special),
                          const SizedBox(width: 12),
                          Text(context.t('language'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Segmented(
                        options: const {'en': 'English', 'ar': 'العربية'},
                        selected: state.language,
                        onSelect: (v) => state.setLanguage(v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.layers_outlined,
                  iconBg: AppColors.warningTint,
                  iconColor: AppColors.warning,
                  title: context.t('app_phase'),
                  subtitle: 'Phase 2 requirements',
                  onTap: () => _info(context, context.t('app_phase'), 'Phase 2 requirements are complete.'),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Row(
                    children: [
                      const _IconBox(icon: Icons.notifications_none, bg: AppColors.warningTint, color: AppColors.warning),
                      const SizedBox(width: 12),
                      Expanded(child: Text(context.t('visit_reminders'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                      Switch(value: state.visitReminders, onChanged: state.setVisitReminders, activeColor: AppColors.success),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.storage_outlined,
                  iconBg: AppColors.infoTint,
                  iconColor: AppColors.info,
                  title: context.t('server_connection'),
                  onTap: () => _info(context, context.t('server_connection'), 'https://acme-dist.odoo.com\nConnected'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.info_outline,
                  iconBg: AppColors.successTint,
                  iconColor: AppColors.success,
                  title: context.t('about'),
                  onTap: () => _info(context, context.t('about'), '${context.t('app_name')}\nVersion 1.0.0'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.science_outlined,
                  iconBg: AppColors.specialTint,
                  iconColor: AppColors.special,
                  title: 'Kitchen sink (dev)',
                  onTap: () => _info(context, 'Kitchen sink (dev)', 'Component playground — dev only.'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.play_arrow_outlined,
                  iconBg: AppColors.warningTint,
                  iconColor: AppColors.warning,
                  title: 'Replay onboarding (dev)',
                  showChevron: false,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Onboarding replay — dev only')),
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.logout,
                  iconBg: const Color(0xFFFBE1DF),
                  iconColor: AppColors.danger,
                  title: context.t('sign_out'),
                  titleColor: AppColors.danger,
                  showChevron: false,
                  onTap: () => _confirmSignOut(context, state),
                ),
                const SizedBox(height: 20),
                Center(child: Text('v1.0.0', style: TextStyle(color: Colors.grey.shade400))),
              ],
            ),
          ),
        );
      },
    );
  }

  void _info(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, AppState state) {
    showAppBottomSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign out?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text("You'll need to sign in again to use the app.", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                state.signOut();
                Navigator.pop(ctx);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              },
              child: const Text('Sign out'),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.bg, required this.color});
  final IconData icon;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
      child: Icon(icon, color: color, size: 15),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.titleColor,
    this.showChevron = true,
  });
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final bool showChevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SectionCard(
        child: Row(
          children: [
            _IconBox(icon: icon, bg: iconBg, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: titleColor)),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            if (showChevron) Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

/// [options] maps a stable value (e.g. 'en') to its display label (e.g. 'English').
class _Segmented extends StatelessWidget {
  const _Segmented({required this.options, required this.selected, required this.onSelect});
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.entries.map((e) {
        return AppChip(label: e.value, selected: e.key == selected, onTap: () => onSelect(e.key));
      }).toList(),
    );
  }
}
