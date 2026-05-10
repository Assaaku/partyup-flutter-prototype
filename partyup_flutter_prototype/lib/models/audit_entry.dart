class AuditEntry {
  AuditEntry({
    required this.action,
    required this.actor,
    required this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String action;
  final String actor;
  final String message;
  final DateTime createdAt;
}
