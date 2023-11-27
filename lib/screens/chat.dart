import 'package:chatting_app/widgets/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String cekilenString = 'deneme';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 222, 219, 219),
        title: const Row(
          children: [Text('aa')],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          PopupMenuButton(
              shadowColor: Colors.grey.shade600,
              icon: const Icon(Icons.more_vert,
                  color: Colors.black), // add this line
              itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'New group',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'New broadcast',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Linked devices',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Starred messages',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ])
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ChatMessage(
                        messageId: cekilenString,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserName(index) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('chats')
        .orderBy('newTextTime', descending: true)
        .get();
    cekilenString = data.docs[index].id;
  }
}
