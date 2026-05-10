import 'package:flutter/material.dart';

import '../screens/create_event_screen.dart';
import '../screens/login_screen.dart';
import '../services/app_services.dart';
import 'security_badge.dart';

class AppLeftPanel extends StatelessWidget {
  const AppLeftPanel({super.key, this.inDrawer = false});

  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final auth = services.auth;
    final events = services.events;

    return AnimatedBuilder(
      animation: Listenable.merge([auth, events]),
      builder: (context, _) {
        final user = auth.currentUser;
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: SizedBox(
              width: inDrawer ? 310 : 280,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                          ),
                        ),
                        child: const Center(child: Text('P', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PartyUp', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                            Text(user.roleLabel, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.45),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(user.isGuest ? 'Та эвентүүдийг үзэж болно. Нэгдэх, хадгалах бол нэвтэрнэ.' : '${user.phoneNumber ?? 'admin'} • баталгаажсан'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              SecurityBadge(icon: Icons.verified_user_outlined, label: 'RBAC', compact: true),
                              SecurityBadge(icon: Icons.history_outlined, label: 'Audit', compact: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (user.isGuest)
                    FilledButton.icon(
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Нэвтрэх / бүртгүүлэх'),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                    )
                  else
                    OutlinedButton.icon(
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Гарах'),
                      onPressed: auth.logout,
                    ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Эвент үүсгэх'),
                    onPressed: user.canCreateEvent
                        ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateEventScreen()))
                        : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Эвент үүсгэхийн тулд нэвтэрнэ үү.'))),
                  ),
                  const SizedBox(height: 22),
                  Text('Шүүлтүүр', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  ...events.categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => events.selectCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                            color: events.selectedCategory == category ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(category == 'Бүгд' ? Icons.grid_view_rounded : Icons.local_activity_outlined, size: 18),
                              const SizedBox(width: 10),
                              Expanded(child: Text(category)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.smart_toy_outlined),
                    title: const Text('AI санал болголт'),
                    subtitle: const Text('Түүх, байршил, ангилал дээр суурилсан mock'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Мэдэгдэл'),
                    subtitle: const Text('Эвент, чат, төлбөрийн сануулга'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
