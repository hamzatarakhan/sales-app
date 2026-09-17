import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../l10n.dart';
import '../root_shell.dart';
import '../theme.dart';
import '../widgets/brand_icon.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _user = TextEditingController(text: 'hamza@acme-dist.example');
  final _pass = TextEditingController(text: 'password');
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final canSubmit = _user.text.trim().isNotEmpty && _pass.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 140),
                  const BrandIcon(size: 96),
                  const SizedBox(height: 24),
                  Text(context.t('app_name'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 8),
                  Text(context.t('sign_in_subtitle'), style: const TextStyle(color: AppColors.textMuted, fontSize: 15)),
                  const SizedBox(height: 36),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.t('username_or_email'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.text)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _user,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'you@company.com',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.divider)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.divider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.t('password'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.text)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pass,
                    obscureText: _obscure,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.divider)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.divider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 18,
                          color: AppColors.textFaint,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: canSubmit
                        ? () {
                            state.signIn();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const RootShell()),
                            );
                          }
                        : null,
                    child: Text(context.t('sign_in')),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => _showChangeServer(context),
                    child: Text(context.t('change_server'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeServer(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.t('change_server')),
        content: TextField(
          decoration: const InputDecoration(hintText: 'https://mycompany.odoo.com'),
          controller: TextEditingController(text: 'https://acme-dist.odoo.com'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.t('cancel'))),
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.t('save'))),
        ],
      ),
    );
  }
}
