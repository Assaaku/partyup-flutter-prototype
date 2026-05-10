import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/app_services.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final user = services.auth.currentUser;

    if (user.isGuest) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 48),
                const SizedBox(height: 12),
                Text('Чат ашиглахын тулд нэвтэрнэ үү', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Хувь болон групп чат нь prototype дээр mock байдлаар харагдана.'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Нэвтрэх'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final chats = [
      ('Open mic group', 'Өнөөдөр 19:30-д хаалга нээгдэнэ.'),
      ('Board game Friday', 'Uno авчрах хүн байна уу?'),
      ('Tech career meetup', 'CV review slot 4 үлдсэн байна.'),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(chat.$1.characters.first)),
            title: Text(chat.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat.$2),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        );
      },
    );
  }
}
