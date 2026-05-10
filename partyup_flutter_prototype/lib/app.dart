import 'package:flutter/material.dart';

import 'screens/admin_panel_screen.dart';
import 'screens/home_shell.dart';
import 'services/app_services.dart';
import 'services/audit_service.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'theme/app_theme.dart';

class PartyUpApp extends StatefulWidget {
  const PartyUpApp({super.key});

  @override
  State<PartyUpApp> createState() => _PartyUpAppState();
}

class _PartyUpAppState extends State<PartyUpApp> {
  late final AuditService _auditService;
  late final PrototypeAuthService _authService;
  late final EventService _eventService;

  @override
  void initState() {
    super.initState();
    _auditService = AuditService();
    _authService = PrototypeAuthService(_auditService);
    _eventService = EventService(_auditService);
  }

  @override
  Widget build(BuildContext context) {
    return AppServices(
      auth: _authService,
      events: _eventService,
      audit: _auditService,
      child: AnimatedBuilder(
        animation: _authService,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PartyUp Prototype',
            theme: AppTheme.light(),
            home: _authService.isAdmin ? const AdminPanelScreen() : const HomeShell(),
          );
        },
      ),
    );
  }
}
