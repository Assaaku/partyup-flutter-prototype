import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../security/security_tactics.dart';
import '../services/app_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _userFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Тэмүүлэн');
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController(text: '18');
  final _userPasswordController = TextEditingController(text: '1234');

  final _adminUsernameController = TextEditingController(text: 'admin');
  final _adminPasswordController = TextEditingController(text: 'pass');

  bool _hideUserPassword = true;
  bool _hideAdminPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _userPasswordController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  void _showResult(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    if (success) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final auth = services.auth;

    return Scaffold(
      appBar: AppBar(title: const Text('Нэвтрэх')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            margin: const EdgeInsets.all(18),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('PartyUp бүртгэл', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('Prototype тул backend байхгүй. Гэхдээ талбар, validation, role guard, audit log ажиллана.', textAlign: TextAlign.center),
                  const SizedBox(height: 18),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(Icons.phone_android_rounded), text: 'Хэрэглэгч'),
                      Tab(icon: Icon(Icons.admin_panel_settings_rounded), text: 'Админ'),
                    ],
                  ),
                  SizedBox(
                    height: 430,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildUserLogin(services),
                        _buildAdminLogin(services),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Нэвтрэхгүй үзэх'),
                    onPressed: () {
                      final result = auth.continueAsGuest();
                      _showResult(result.message, result.success);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserLogin(AppServices services) {
    return Form(
      key: _userFormKey,
      child: ListView(
        padding: const EdgeInsets.only(top: 18),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Нэр', prefixIcon: Icon(Icons.person_outline_rounded)),
            validator: (value) => value == null || value.trim().isEmpty ? 'Нэр оруулна уу.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, EightDigitPhoneFormatter()],
            decoration: const InputDecoration(
              labelText: 'Утасны дугаар',
              prefixText: '+976 ',
              prefixIcon: Icon(Icons.call_outlined),
              helperText: 'Жишээ: +976 99112233',
            ),
            validator: (value) => MongolianPhoneValidator.isValidLocalNumber(value ?? '') ? null : '8 оронтой дугаар оруулна уу.',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Нас', prefixIcon: Icon(Icons.cake_outlined)),
            validator: (value) {
              final age = int.tryParse(value ?? '');
              if (age == null) return 'Насаа тоогоор оруулна уу.';
              if (age < 13) return 'Насны шаардлага хангахгүй байна.';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _userPasswordController,
            obscureText: _hideUserPassword,
            decoration: InputDecoration(
              labelText: 'Нууц үг',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_hideUserPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _hideUserPassword = !_hideUserPassword),
              ),
            ),
            validator: (value) => value != null && value.trim().length >= 4 ? null : '4+ тэмдэгт шаардлагатай.',
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            icon: const Icon(Icons.login_rounded),
            label: const Text('Хэрэглэгчээр нэвтрэх'),
            onPressed: () {
              if (!_userFormKey.currentState!.validate()) return;
              final result = services.auth.signInWithPhone(
                displayName: _nameController.text,
                localPhoneDigits: _phoneController.text,
                age: int.parse(_ageController.text),
                password: _userPasswordController.text,
              );
              _showResult(result.message, result.success);
            },
          ),
          const SizedBox(height: 12),
          const Text('Тайлбар: Firebase/JWT backend холбогдоогүй тул энэ нь frontend prototype login юм.'),
        ],
      ),
    );
  }

  Widget _buildAdminLogin(AppServices services) {
    return Form(
      key: _adminFormKey,
      child: ListView(
        padding: const EdgeInsets.only(top: 18),
        children: [
          const Text('Demo админ эрх: username = admin, password = pass'),
          const SizedBox(height: 12),
          TextFormField(
            controller: _adminUsernameController,
            decoration: const InputDecoration(labelText: 'Admin username', prefixIcon: Icon(Icons.admin_panel_settings_outlined)),
            validator: (value) => value == null || value.trim().isEmpty ? 'Username оруулна уу.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _adminPasswordController,
            obscureText: _hideAdminPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_hideAdminPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _hideAdminPassword = !_hideAdminPassword),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Password оруулна уу.' : null,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            icon: const Icon(Icons.security_rounded),
            label: const Text('Админ самбар руу орох'),
            onPressed: () {
              if (!_adminFormKey.currentState!.validate()) return;
              final result = services.auth.signInAdmin(
                username: _adminUsernameController.text,
                password: _adminPasswordController.text,
              );
              _showResult(result.message, result.success);
            },
          ),
          const SizedBox(height: 12),
          const Text('Аюулгүй байдлын mock: буруу олон оролдлого хийвэл түр lock хийнэ, audit log-д бүртгэнэ.'),
        ],
      ),
    );
  }
}
