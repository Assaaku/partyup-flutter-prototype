import 'package:flutter/widgets.dart';

import 'audit_service.dart';
import 'auth_service.dart';
import 'event_service.dart';

class AppServices extends InheritedWidget {
  const AppServices({
    super.key,
    required this.auth,
    required this.events,
    required this.audit,
    required super.child,
  });

  final PrototypeAuthService auth;
  final EventService events;
  final AuditService audit;

  static AppServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppServices>();
    assert(scope != null, 'AppServices is missing above this widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) {
    return auth != oldWidget.auth || events != oldWidget.events || audit != oldWidget.audit;
  }
}
