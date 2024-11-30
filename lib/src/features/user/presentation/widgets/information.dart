import 'package:app_tcareer/src/features/user/presentation/controllers/user_connection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget information(
    {required String fullName,
    required WidgetRef ref,
    required BuildContext context,
    String? userId,
    String? expertise,
    String? follows,
    String? avatar,
    String? friends}) {
  final connectionController =
      ref.watch(userConnectionControllerProvider(userId ?? ""));
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          fullName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    ),
    subtitle: Row(
      children: [
        GestureDetector(
          onTap: follows != "0"
              ? () async {
                  await connectionController.getFollowers();
                  await connectionController.showUserFollowed(context);
                }
              : null,
          child: Text(
            follows != "0" ? "$follows người theo dõi" : "0 người theo dõi",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: friends != "0"
              ? () async {
                  await connectionController.getFriends();
                  await connectionController.showUserFriends(context);
                }
              : null,
          child: Text(
            friends != null ? "$friends người bạn" : "0 người bạn",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    ),
    trailing: CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(avatar ??
          "https://ui-avatars.com/api/?name=$fullName&background=random"),
    ),
  );
}
