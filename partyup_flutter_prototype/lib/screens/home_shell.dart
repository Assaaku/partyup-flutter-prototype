import 'package:flutter/material.dart';

import '../services/app_services.dart';
import '../widgets/app_left_panel.dart';
import 'chat_screen.dart';
import 'event_feed_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 980;
    final services = AppServices.of(context);
    final user = services.auth.currentUser;

    final pages = const [
      EventFeedScreen(),
      MapScreen(),
      ChatScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      drawer: wide ? null : const Drawer(child: AppLeftPanel(inDrawer: true)),
      appBar: AppBar(
        title: Text(_titleForIndex(_index)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                user.isGuest ? 'Зочин' : user.displayName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (wide) const AppLeftPanel(),
          if (wide) const VerticalDivider(width: 1),
          Expanded(child: pages[_index]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Эвентүүд'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Газрын зураг'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Чат'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Профайл'),
        ],
      ),
    );
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Ойролцоох эвентүүд';
      case 1:
        return 'Газрын зураг';
      case 2:
        return 'Чат';
      case 3:
        return 'Профайл';
      default:
        return 'PartyUp';
    }
  }
}
