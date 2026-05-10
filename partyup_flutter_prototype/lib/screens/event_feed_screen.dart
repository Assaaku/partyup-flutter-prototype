import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/app_services.dart';
import '../widgets/event_card.dart';
import '../widgets/security_badge.dart';

class EventFeedScreen extends StatelessWidget {
  const EventFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final auth = services.auth;
    final events = services.events;

    return AnimatedBuilder(
      animation: Listenable.merge([auth, events]),
      builder: (context, _) {
        final user = auth.currentUser;
        final list = events.events;
        final recommended = events.recommendationsFor(user);
        final width = MediaQuery.sizeOf(context).width;
        final crossAxisCount = width >= 520 ? 2 : 1;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.secondaryContainer,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Өнөөдөр хаашаа явах вэ?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                                const SizedBox(height: 8),
                                Text(
                                  user.isGuest
                                      ? 'Бүртгэлгүйгээр эвентүүдийг үзэж болно. Нэгдэх, хадгалах, эвент үүсгэх бол нэвтэрнэ.'
                                      : '${user.displayName}, таны нас, сонирхол, түүх дээр суурилсан санал болголтыг mock байдлаар харуулж байна.',
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: const [
                                    SecurityBadge(icon: Icons.location_on_outlined, label: 'Байршил'),
                                    SecurityBadge(icon: Icons.smart_toy_outlined, label: 'AI санал'),
                                    SecurityBadge(icon: Icons.lock_outline_rounded, label: 'Privacy'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (user.isGuest)
                            FilledButton.icon(
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Нэвтрэх'),
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: events.search,
                      decoration: const InputDecoration(
                        hintText: 'Эвент, газар, tag хайх...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = events.categories[index];
                          return ChoiceChip(
                            label: Text(category),
                            selected: events.selectedCategory == category,
                            onSelected: (_) => events.selectCategory(category),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: events.categories.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('AI санал болгосон', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 94,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final event = recommended[index];
                          return Container(
                            width: 260,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(event.emoji, style: const TextStyle(fontSize: 28)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('${event.category} • ${event.distanceKm.toStringAsFixed(1)} км', style: Theme.of(context).textTheme.bodySmall),
                                      Text(event.priceLabel, style: Theme.of(context).textTheme.labelMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text('Нийт эвентүүд', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        Text('2 баганаар доош scroll хийнэ', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 430,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => EventCard(event: list[index]),
                  childCount: list.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
