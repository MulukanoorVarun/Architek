import 'package:flutter/material.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {},
      {
        'name': 'Michael Chen',
        'lastMessage': 'The project timeline looks good.',
        'time': 'Yesterday',
        'unread': 0,
        'avatar': 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          final name = chat['name'] ?? 'Unknown';
          final lastMessage = chat['lastMessage'] ?? '';
          final time = chat['time'] ?? '';
          final unread = chat['unread'] ?? 0;
          final avatarUrl = chat['avatar'];

          return ListTile(
            leading: avatarUrl != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            )
                : const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(name),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.secondary[600],
                    fontSize: 12,
                  ),
                ),
                if (unread > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary[700],
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Navigate to chat detail screen
            },
          );
        },
      ),
    );
  }
}
