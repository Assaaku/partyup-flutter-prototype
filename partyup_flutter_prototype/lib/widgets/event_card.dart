import 'package:flutter/material.dart';

import '../models/event.dart';
import '../screens/event_detail_screen.dart';
import '../security/security_tactics.dart';
import '../services/app_services.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final PartyEvent event;

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final diff = dateTime.difference(now);
    if (diff.inHours < 24) return 'Өнөөдөр ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 1) return 'Маргааш ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final user = services.auth.currentUser;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: event.id))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Text(event.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.organizerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            if (event.isVerified) Icon(Icons.verified_rounded, size: 17, color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                        Text('${event.organizerTypeLabel} • ${event.distanceKm.toStringAsFixed(1)} км', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (event.isVip)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('VIP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(event.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(
                event.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _MetaChip(icon: Icons.schedule_rounded, label: _formatDate(event.dateTime)),
                  _MetaChip(icon: Icons.place_outlined, label: event.locationName),
                  _MetaChip(icon: Icons.payments_outlined, label: event.priceLabel),
                  _MetaChip(icon: Icons.groups_2_outlined, label: '${event.joinedCount}/${event.capacity}'),
                  _MetaChip(icon: Icons.cake_outlined, label: '${event.ageLimit}+'),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: event.tags.map((tag) => Text('#$tag', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600))).toList(),
              ),
              const Spacer(),
              const Divider(height: 22),
              Row(
                children: [
                  _ActionButton(
                    icon: event.joined ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                    label: event.joined ? 'Нэгдсэн' : 'Нэгдэх',
                    onTap: () {
                      if (user.isGuest) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SecurityMessages.guestNeedsLogin)));
                        return;
                      }
                      services.events.joinEvent(event.id, user);
                    },
                  ),
                  _ActionButton(
                    icon: event.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    label: 'Хадгалах',
                    onTap: () {
                      if (user.isGuest) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SecurityMessages.guestNeedsLogin)));
                        return;
                      }
                      services.events.toggleSaved(event.id, user);
                    },
                  ),
                  _ActionButton(icon: Icons.chat_bubble_outline_rounded, label: '${event.commentsCount}', onTap: () {}),
                  _ActionButton(icon: Icons.ios_share_rounded, label: 'Share', onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 5),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 4),
              Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
