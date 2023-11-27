import 'package:chatting_app/widgets/custom_builder.dart';
import 'package:chatting_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GroupMessage extends StatefulWidget {
  const GroupMessage({super.key, required this.messageId});

  final messageId;

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  ScrollController controller = ScrollController();
  int listLength = 20;
  int initialLenght = 30;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? loadedMessages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
      if (initialLenght != loadedMessages!.length) {
        if (controller.position.maxScrollExtent -
                controller.position.maxScrollExtent / 3 <
            controller.offset.toDouble()) {
          setState(() {
            controller =
                ScrollController(initialScrollOffset: controller.offset);
            initialLenght = initialLenght + 30;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authendicatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.messageId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        loadedMessages = chatSnapshots.data!.docs;
        return Scrollbar(
          //controller: controller,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: SingleChildScrollView(
              controller: controller,
              //dragStartBehavior: DragStartBehavior.start,
              reverse: true,
              child: Column(
                children: [
                  ColumnBuilder(
                    // addAutomaticKeepAlives: false,
                    /* padding: const EdgeInsets.only(
                      bottom: 10,
                      left: 5,
                    ), */
                    // reverse: true,
                    //! ITEM COUNT'U DİNAMİK YAP CHAT EKRANINDA BUTONA BAGLA
                    itemCount: lenghtMethod(),
                    itemBuilder: (context, index) {
                      final chatMessage = loadedMessages![index].data();
                      final nextChatMessages =
                          index + 1 < loadedMessages!.length
                              ? loadedMessages![index + 1].data()
                              : null;
                      final currentMessageUserId = chatMessage['userId'];
                      final nextMessageUserId = nextChatMessages != null
                          ? nextChatMessages['userId']
                          : null;
                      final nextUserIsSame =
                          nextMessageUserId == currentMessageUserId;
                      if (nextUserIsSame) {
                        return MessageBubble.next(
                            image: chatMessage['textImage'],
                            message: chatMessage['text'],
                            date: chatMessage['createdAt'] ?? Timestamp.now(),
                            isMe:
                                authendicatedUser.uid == currentMessageUserId);
                      } else {
                        return MessageBubble.first(
                            image: chatMessage['textImage'],
                            userImage: chatMessage['userImage'],
                            username: chatMessage['username'],
                            message: chatMessage['text'],
                            date: chatMessage['createdAt'] ?? Timestamp.now(),
                            isMe:
                                authendicatedUser.uid == currentMessageUserId);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int lenghtMethod() {
    if (loadedMessages!.length < 30) {
      return loadedMessages!.length;
    } else {
      if (initialLenght > loadedMessages!.length) {
        initialLenght = loadedMessages!.length;
        return loadedMessages!.length;
      } else {
        return initialLenght;
      }
    }
  }
}
