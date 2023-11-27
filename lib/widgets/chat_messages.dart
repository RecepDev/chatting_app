import 'package:chatting_app/widgets/message_bubble_1to1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.messageId});

  final messageId;

  @override
  Widget build(BuildContext context) {
    final authendicatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(messageId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
        final loadedMessages = chatSnapshots.data!.docs;
        //! GROUP MESSAGE GİBİ YAP

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessages = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessages != null ? nextChatMessages['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubblePrivate.next(
                  image: chatMessage['textImage'],
                  message: chatMessage['text'],
                  date: chatMessage['createdAt'] ?? Timestamp.now(),
                  isMe: authendicatedUser.uid == currentMessageUserId);
            } else {
              return MessageBubblePrivate.first(
                  image: chatMessage['textImage'],
                  message: chatMessage['text'],
                  date: chatMessage['createdAt'] ?? Timestamp.now(),
                  isMe: authendicatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
