import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/app_user.dart';
import '../models/event.dart';
import '../security/security_tactics.dart';
import 'audit_service.dart';

class EventService extends ChangeNotifier {
  EventService(this._auditService) : _events = List.of(SampleData.events);

  final AuditService _auditService;
  final List<PartyEvent> _events;
  String _selectedCategory = 'Бүгд';
  String _query = '';

  String get selectedCategory => _selectedCategory;
  String get query => _query;
  List<String> get categories => SampleData.categories;

  List<PartyEvent> get events {
    final normalizedQuery = _query.trim().toLowerCase();
    return _events.where((event) {
      final categoryMatches = _selectedCategory == 'Бүгд' || event.category == _selectedCategory;
      final queryMatches = normalizedQuery.isEmpty ||
          event.title.toLowerCase().contains(normalizedQuery) ||
          event.description.toLowerCase().contains(normalizedQuery) ||
          event.locationName.toLowerCase().contains(normalizedQuery) ||
          event.tags.any((tag) => tag.toLowerCase().contains(normalizedQuery));
      return event.status != EventStatus.hidden && categoryMatches && queryMatches;
    }).toList()
      ..sort((a, b) {
        if (a.isVip != b.isVip) return a.isVip ? -1 : 1;
        return a.dateTime.compareTo(b.dateTime);
      });
  }

  List<PartyEvent> recommendationsFor(AppUser user) {
    final base = events;
    if (user.isGuest) {
      return base.take(4).toList();
    }
    return base.where((event) => event.ageLimit <= (user.age ?? 99)).take(5).toList();
  }

  List<PartyEvent> get adminEvents => List.unmodifiable(_events);

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void joinEvent(String eventId, AppUser user) {
    if (user.isGuest) return;
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return;
    final event = _events[index];
    if (event.joined || event.spotsLeft <= 0) return;
    _events[index] = event.copyWith(joined: true, joinedCount: event.joinedCount + 1);
    _auditService.record(action: 'event_join', actor: user.displayName, message: '${event.title} эвентэд нэгдлээ');
    notifyListeners();
  }

  void toggleSaved(String eventId, AppUser user) {
    if (user.isGuest) return;
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return;
    final event = _events[index];
    _events[index] = event.copyWith(saved: !event.saved);
    _auditService.record(action: 'event_save', actor: user.displayName, message: '${event.title} эвентийн хадгалсан төлөв өөрчлөгдлөө');
    notifyListeners();
  }

  void createEvent({
    required AppUser actor,
    required String title,
    required String description,
    required String category,
    required String locationName,
    required int capacity,
    required int priceMnt,
    required int ageLimit,
    required bool corporate,
  }) {
    final event = PartyEvent(
      id: 'e-${DateTime.now().millisecondsSinceEpoch}',
      title: InputSanitizer.cleanText(title, maxLength: 80),
      organizerName: actor.displayName,
      organizerType: corporate ? OrganizerType.organization : OrganizerType.personal,
      description: InputSanitizer.cleanText(description, maxLength: 420),
      category: category,
      locationName: InputSanitizer.cleanText(locationName, maxLength: 80),
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      capacity: capacity,
      joinedCount: 1,
      priceMnt: priceMnt,
      emoji: corporate ? '🏢' : '✨',
      tags: corporate ? ['байгууллага', 'networking'] : ['жижиг бүлэг', 'шинэ уулзалт'],
      ageLimit: ageLimit,
      distanceKm: 2.8,
      status: EventStatus.pending,
    );
    _events.insert(0, event);
    _auditService.record(action: 'event_create', actor: actor.displayName, message: '${event.title} эвент үүсгэгдлээ');
    notifyListeners();
  }

  void setEventStatus(String eventId, EventStatus status, AppUser admin) {
    if (!admin.isAdmin) return;
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return;
    final event = _events[index];
    _events[index] = event.copyWith(status: status);
    _auditService.record(action: 'moderation', actor: admin.displayName, message: '${event.title} төлөв: ${status.name}');
    notifyListeners();
  }
}
