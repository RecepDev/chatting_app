import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListChat extends StatefulWidget {
  const ListChat({super.key, required this.isChatPressed});

  //  title = loadedChatsNames[index].id;
  //                               gelenId = loadedChatsNames[index].id;
  //                             sendedId = loadedChatsNames[index].id;
  //                            isChatPressed = !isChatPressed;

  final isChatPressed;

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  @override
  Widget build(BuildContext context) {
    var isChatPressed2 = widget.isChatPressed;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          var loadedChatsNames = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.chat),
                    title: Text(loadedChatsNames[index].id),
                    onTap: () {
                      setState(() {
                        isChatPressed2 = !isChatPressed2;
                      });
                    },
                  ),
                );
              },
            ),
          );
        });
  }
}
