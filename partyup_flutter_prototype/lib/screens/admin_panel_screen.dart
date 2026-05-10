import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/app_services.dart';
import '../widgets/stat_card.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([services.auth, services.events, services.audit]),
      builder: (context, _) {
        final admin = services.auth.currentUser;
        final events = services.events.adminEvents;
        final pending = events.where((event) => event.status == EventStatus.pending).length;
        final hidden = events.where((event) => event.status == EventStatus.hidden).length;
        final corporate = events.where((event) => event.isCorporate).length;
        final totalJoined = events.fold<int>(0, (sum, event) => sum + event.joinedCount);

        return Scaffold(
          appBar: AppBar(
            title: const Text('PartyUp админ самбар'),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Гарах'),
                onPressed: services.auth.logout,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Сайн байна уу, ${admin.displayName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Chip(label: Text('RBAC: admin only')),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 560 ? 2 : 1;
                  final cards = [
                    StatCard(title: 'Нийт эвент', value: '${events.length}', icon: Icons.event_available_rounded, subtitle: 'approved + pending'),
                    StatCard(title: 'Pending', value: '$pending', icon: Icons.pending_actions_rounded, subtitle: 'баталгаажуулах шаардлагатай'),
                    StatCard(title: 'Байгууллага', value: '$corporate', icon: Icons.business_center_outlined, subtitle: 'corpo event'),
                    StatCard(title: 'Оролцоо', value: '$totalJoined', icon: Icons.groups_2_outlined, subtitle: 'нийт joined count'),
                  ];
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 112,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) => cards[index],
                  );
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Админ контролууд', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _AdminAction(icon: Icons.verified_user_outlined, label: 'Хэрэглэгч баталгаажуулах'),
                          _AdminAction(icon: Icons.business_outlined, label: 'Байгууллага шалгах'),
                          _AdminAction(icon: Icons.report_gmailerrorred_outlined, label: 'Санал хүсэлт шийдвэрлэх'),
                          _AdminAction(icon: Icons.category_outlined, label: 'Ангилал удирдах'),
                          _AdminAction(icon: Icons.notifications_active_outlined, label: 'Мэдэгдэл илгээх'),
                          _AdminAction(icon: Icons.security_outlined, label: 'Хандалтын хяналт'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Эвент moderation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      ...events.map((event) => _ModerationTile(event: event)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Audit log', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      if (services.audit.entries.isEmpty) const Text('Одоогоор бүртгэл алга.'),
                      ...services.audit.entries.take(12).map(
                            (entry) => ListTile(
                              leading: const Icon(Icons.history_rounded),
                              title: Text(entry.message),
                              subtitle: Text('${entry.actor} • ${entry.action} • ${entry.createdAt.hour.toString().padLeft(2, '0')}:${entry.createdAt.minute.toString().padLeft(2, '0')}'),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminAction extends StatelessWidget {
  const _AdminAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label mock action'))),
    );
  }
}

class _ModerationTile extends StatelessWidget {
  const _ModerationTile({required this.event});

  final PartyEvent event;

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final admin = services.auth.currentUser;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35),
      child: ListTile(
        leading: CircleAvatar(child: Text(event.emoji)),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${event.organizerName} • ${event.status.name} • ${event.organizerTypeLabel}'),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton.filledTonal(
              tooltip: 'Approve',
              icon: const Icon(Icons.check_rounded),
              onPressed: () => services.events.setEventStatus(event.id, EventStatus.approved, admin),
            ),
            IconButton.filledTonal(
              tooltip: 'Hide',
              icon: const Icon(Icons.visibility_off_outlined),
              onPressed: () => services.events.setEventStatus(event.id, EventStatus.hidden, admin),
            ),
          ],
        ),
      ),
    );
  }
}
