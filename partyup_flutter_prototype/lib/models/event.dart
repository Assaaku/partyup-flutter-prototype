enum OrganizerType { personal, organization }

enum EventStatus { draft, pending, approved, hidden }

class PartyEvent {
  const PartyEvent({
    required this.id,
    required this.title,
    required this.organizerName,
    required this.organizerType,
    required this.description,
    required this.category,
    required this.locationName,
    required this.dateTime,
    required this.capacity,
    required this.joinedCount,
    required this.priceMnt,
    required this.emoji,
    required this.tags,
    required this.ageLimit,
    required this.distanceKm,
    this.isVip = false,
    this.isVerified = false,
    this.status = EventStatus.approved,
    this.saved = false,
    this.joined = false,
    this.commentsCount = 0,
  });

  final String id;
  final String title;
  final String organizerName;
  final OrganizerType organizerType;
  final String description;
  final String category;
  final String locationName;
  final DateTime dateTime;
  final int capacity;
  final int joinedCount;
  final int priceMnt;
  final String emoji;
  final List<String> tags;
  final int ageLimit;
  final double distanceKm;
  final bool isVip;
  final bool isVerified;
  final EventStatus status;
  final bool saved;
  final bool joined;
  final int commentsCount;

  bool get isCorporate => organizerType == OrganizerType.organization;
  bool get isFree => priceMnt == 0;
  int get spotsLeft => capacity - joinedCount;
  String get organizerTypeLabel => isCorporate ? 'Байгууллагын эвент' : 'Жижиг бүлгийн уулзалт';
  String get priceLabel => isFree ? 'Үнэгүй' : '${priceMnt ~/ 1000}k₮';

  PartyEvent copyWith({
    String? id,
    String? title,
    String? organizerName,
    OrganizerType? organizerType,
    String? description,
    String? category,
    String? locationName,
    DateTime? dateTime,
    int? capacity,
    int? joinedCount,
    int? priceMnt,
    String? emoji,
    List<String>? tags,
    int? ageLimit,
    double? distanceKm,
    bool? isVip,
    bool? isVerified,
    EventStatus? status,
    bool? saved,
    bool? joined,
    int? commentsCount,
  }) {
    return PartyEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      organizerName: organizerName ?? this.organizerName,
      organizerType: organizerType ?? this.organizerType,
      description: description ?? this.description,
      category: category ?? this.category,
      locationName: locationName ?? this.locationName,
      dateTime: dateTime ?? this.dateTime,
      capacity: capacity ?? this.capacity,
      joinedCount: joinedCount ?? this.joinedCount,
      priceMnt: priceMnt ?? this.priceMnt,
      emoji: emoji ?? this.emoji,
      tags: tags ?? this.tags,
      ageLimit: ageLimit ?? this.ageLimit,
      distanceKm: distanceKm ?? this.distanceKm,
      isVip: isVip ?? this.isVip,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      saved: saved ?? this.saved,
      joined: joined ?? this.joined,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
