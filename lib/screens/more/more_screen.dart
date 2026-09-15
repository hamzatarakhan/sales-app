import 'package:flutter/material.dart';
import '../../app_scope.dart';
import '../../app_state.dart';
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
          appBar: AppBar(title: const Text('More')),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(state.userEmail, style: TextStyle(color: Colors.grey.shade600)),
                      Text(state.userCompany, style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.person_outline,
                  iconBg: const Color(0xFFE3F0FD),
                  iconColor: AppColors.primary,
                  title: 'Profile',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _IconBox(icon: Icons.contrast, bg: const Color(0xFFEDE7F6), color: const Color(0xFF7E57C2)),
                          const SizedBox(width: 12),
                          const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Segmented(
                        options: const ['System', 'Light', 'Dark'],
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
                          _IconBox(icon: Icons.translate, bg: const Color(0xFFEDE7F6), color: const Color(0xFF7E57C2)),
                          const SizedBox(width: 12),
                          const Text('Language', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Segmented(
                        options: const ['English', 'العربية'],
                        selected: state.language == 'en' ? 'English' : 'العربية',
                        onSelect: (v) => state.setLanguage(v == 'English' ? 'en' : 'ar'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.layers_outlined,
                  iconBg: const Color(0xFFFCEFD1),
                  iconColor: const Color(0xFFB07D12),
                  title: 'App phase',
                  subtitle: 'Phase 2 requirements',
                  onTap: () => _info(context, 'App phase', 'Phase 2 requirements are complete.'),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Row(
                    children: [
                      _IconBox(icon: Icons.notifications_none, bg: const Color(0xFFFCEFD1), color: const Color(0xFFB07D12)),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Visit reminders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                      Switch(value: state.visitReminders, onChanged: state.setVisitReminders, activeColor: AppColors.doneFg),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.storage_outlined,
                  iconBg: const Color(0xFFE3F0FD),
                  iconColor: AppColors.primary,
                  title: 'Server / connection',
                  onTap: () => _info(context, 'Server / connection', 'https://acme-dist.odoo.com\nConnected'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.info_outline,
                  iconBg: const Color(0xFFE3F5E8),
                  iconColor: AppColors.doneFg,
                  title: 'About',
                  onTap: () => _info(context, 'About', 'Sales Rep\nVersion 1.0.0'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.science_outlined,
                  iconBg: const Color(0xFFEDE7F6),
                  iconColor: const Color(0xFF7E57C2),
                  title: 'Kitchen sink (dev)',
                  onTap: () => _info(context, 'Kitchen sink (dev)', 'Component playground — dev only.'),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.play_arrow_outlined,
                  iconBg: const Color(0xFFFCEFD1),
                  iconColor: const Color(0xFFB07D12),
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
                  title: 'Sign out',
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sign out?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 4),
            Text("You'll need to sign in again to use the app.", style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 20),
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: titleColor)),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
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

class _Segmented extends StatelessWidget {
  const _Segmented({required this.options, required this.selected, required this.onSelect});
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((o) {
        final sel = o == selected;
        return ChoiceChip(
          label: Text(o),
          selected: sel,
          onSelected: (_) => onSelect(o),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w700),
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}
