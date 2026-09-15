import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../l10n.dart';
import '../root_shell.dart';
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
                  const BrandIcon(size: 88),
                  const SizedBox(height: 20),
                  Text(context.t('app_name'), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(context.t('sign_in_subtitle'), style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.t('username_or_email'), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _user,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(hintText: 'you@company.com'),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.t('password'), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pass,
                    obscureText: _obscure,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
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
