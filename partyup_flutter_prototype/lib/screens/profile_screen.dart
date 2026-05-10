import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/app_services.dart';
import '../widgets/security_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final user = services.auth.currentUser;
    final joined = services.events.adminEvents.where((event) => event.joined).toList();
    final saved = services.events.adminEvents.where((event) => event.saved).toList();

    if (user.isGuest) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline_rounded, size: 52),
                const SizedBox(height: 12),
                Text('Бүртгэлгүй хэрэглэгч', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Эвент харах боломжтой. Харин нэгдэх, хадгалах, чатлах, эвент үүсгэхэд нэвтрэлт шаардлагатай.'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Нэвтрэх'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 32, child: Text(user.displayName.characters.first, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                          Text('${user.roleLabel} • ${user.phoneNumber ?? 'admin'}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SecurityBadge(icon: Icons.verified_user_outlined, label: 'Баталгаажсан'),
                    SecurityBadge(icon: Icons.lock_outline_rounded, label: 'Нууцлал'),
                    SecurityBadge(icon: Icons.history_outlined, label: 'Түүх бүртгэл'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Оролцсон эвентийн түүх', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                if (joined.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('Одоогоор нэгдсэн эвент алга.')),
                ...joined.map((event) => ListTile(leading: Text(event.emoji, style: const TextStyle(fontSize: 24)), title: Text(event.title), subtitle: Text(event.locationName))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Хадгалсан эвентүүд', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                if (saved.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('Одоогоор хадгалсан эвент алга.')),
                ...saved.map((event) => ListTile(leading: Text(event.emoji, style: const TextStyle(fontSize: 24)), title: Text(event.title), subtitle: Text(event.priceLabel))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
