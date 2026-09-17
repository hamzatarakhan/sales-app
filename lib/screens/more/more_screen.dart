import 'package:flutter/cupertino.dart';
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
                      Text(state.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(state.userEmail, style: const TextStyle(color: AppColors.textMuted)),
                      Text(state.userCompany, style: const TextStyle(color: AppColors.textFaint)),
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
                          _IconBox(icon: Icons.contrast, bg: AppTones.specialTint(context), color: AppTones.special(context)),
                          const SizedBox(width: 12),
                          Text(context.t('appearance'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
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
                          _IconBox(icon: Icons.translate, bg: AppTones.specialTint(context), color: AppTones.special(context)),
                          const SizedBox(width: 12),
                          Text(context.t('language'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
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
                  iconBg: AppTones.warningTint(context),
                  iconColor: AppTones.warning(context),
                  title: context.t('app_phase'),
                  subtitle: 'Phase 2 requirements',
                  onTap: () => _info(context, context.t('app_phase'), 'Phase 2 requirements are complete.'),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Row(
                    children: [
                      _IconBox(icon: Icons.notifications_none, bg: AppTones.warningTint(context), color: AppTones.warning(context)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(context.t('visit_reminders'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      CupertinoSwitch(value: state.visitReminders, onChanged: state.setVisitReminders, activeTrackColor: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.storage_outlined,
                  iconBg: AppTones.infoTint(context),
                  iconColor: AppTones.info(context),
                  title: context.t('server_connection'),
                  onTap: () => _info(context, context.t('server_connection'), 'https://acme-dist.odoo.com\nConnected'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.info_outline,
                  iconBg: AppTones.successTint(context),
                  iconColor: AppTones.success(context),
                  title: context.t('about'),
                  onTap: () => _info(context, context.t('about'), '${context.t('app_name')}\nVersion 1.0.0'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.science_outlined,
                  iconBg: AppTones.specialTint(context),
                  iconColor: AppTones.special(context),
                  title: 'Kitchen sink (dev)',
                  onTap: () => _info(context, 'Kitchen sink (dev)', 'Component playground — dev only.'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.play_arrow_outlined,
                  iconBg: AppTones.warningTint(context),
                  iconColor: AppTones.warning(context),
                  title: 'Replay onboarding (dev)',
                  showChevron: false,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Onboarding replay — dev only')),
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.logout,
                  iconBg: AppTones.dangerTint(context),
                  iconColor: AppTones.danger(context),
                  title: context.t('sign_out'),
                  titleColor: AppTones.danger(context),
                  showChevron: false,
                  onTap: () => _confirmSignOut(context, state),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('v1.0.0', style: TextStyle(color: AppColors.textFaint))),
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
            const Text('Sign out?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text("You'll need to sign in again to use the app.", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTones.danger(context)),
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
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: titleColor)),
                  if (subtitle != null) Text(subtitle!, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            if (showChevron) Icon(Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left : Icons.chevron_right, color: AppColors.textFaint),
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
