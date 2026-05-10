import 'package:flutter/material.dart';

import '../models/event.dart';
import '../security/security_tactics.dart';
import '../services/app_services.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);

    return AnimatedBuilder(
      animation: services.events,
      builder: (context, _) {
        final event = services.events.adminEvents.firstWhere((item) => item.id == eventId);
        final user = services.auth.currentUser;
        return Scaffold(
          appBar: AppBar(title: const Text('Эвентийн дэлгэрэнгүй')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 34, child: Text(event.emoji, style: const TextStyle(fontSize: 30))),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                                Text('${event.organizerName} • ${event.organizerTypeLabel}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(event.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45)),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoTile(icon: Icons.category_outlined, title: 'Ангилал', value: event.category),
                          _InfoTile(icon: Icons.place_outlined, title: 'Байршил', value: event.locationName),
                          _InfoTile(icon: Icons.people_alt_outlined, title: 'Оролцогч', value: '${event.joinedCount}/${event.capacity}'),
                          _InfoTile(icon: Icons.payments_outlined, title: 'Үнэ', value: event.priceLabel),
                          _InfoTile(icon: Icons.cake_outlined, title: 'Нас', value: '${event.ageLimit}+'),
                          _InfoTile(icon: Icons.near_me_outlined, title: 'Зай', value: '${event.distanceKm.toStringAsFixed(1)} км'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: Icon(event.joined ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded),
                              label: Text(event.joined ? 'Нэгдсэн' : 'Эвентэд нэгдэх'),
                              onPressed: event.joined
                                  ? null
                                  : () {
                                      if (user.isGuest) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SecurityMessages.guestNeedsLogin)));
                                        return;
                                      }
                                      services.events.joinEvent(event.id, user);
                                    },
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.filledTonal(
                            icon: Icon(event.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
                            onPressed: () {
                              if (user.isGuest) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SecurityMessages.guestNeedsLogin)));
                                return;
                              }
                              services.events.toggleSaved(event.id, user);
                            },
                          ),
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
                      Text('Сэтгэгдэл ба чат preview', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      const ListTile(
                        leading: CircleAvatar(child: Text('A')),
                        title: Text('Орохдоо найзаа дагуулж болох уу?'),
                        subtitle: Text('Зохион байгуулагч: Болно, capacity үлдсэн байгаа.'),
                      ),
                      const ListTile(
                        leading: CircleAvatar(child: Text('B')),
                        title: Text('Байршлыг map дээрээс харж болох уу?'),
                        subtitle: Text('Footer дээрх Газрын зураг tab-аар орж харна.'),
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelSmall),
                Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
