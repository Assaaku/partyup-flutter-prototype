import 'package:flutter/foundation.dart';

import '../models/audit_entry.dart';

class AuditService extends ChangeNotifier {
  final List<AuditEntry> _entries = [];

  List<AuditEntry> get entries => List.unmodifiable(_entries.reversed);

  void record({
    required String action,
    required String actor,
    required String message,
  }) {
    _entries.add(AuditEntry(action: action, actor: actor, message: message));
    notifyListeners();
  }
}
