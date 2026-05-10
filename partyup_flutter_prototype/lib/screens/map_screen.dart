import 'package:flutter/material.dart';

import '../services/app_services.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);

    return AnimatedBuilder(
      animation: services.events,
      builder: (context, _) {
        final visibleEvents = services.events.events.take(6).toList();
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Center(
                      child: Text(
                        'assets/images/map.png байрлуулаарай',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.05)),
            ),
            Positioned(
              left: 18,
              top: 18,
              right: 18,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Газрын зургийн API mock: map.png asset ашиглаж байна. Жинхэнэ Google Maps/Mapbox API-г backend/API layer-тэй холбож болно.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, -8))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Ойролцоох эвентүүд', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_up_rounded),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 132,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: visibleEvents.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final event = visibleEvents[index];
                          return Container(
                            width: 260,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(event.emoji, style: const TextStyle(fontSize: 26)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900))),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(event.locationName, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.near_me_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 4),
                                    Text('${event.distanceKm.toStringAsFixed(1)} км'),
                                    const Spacer(),
                                    Text(event.priceLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
