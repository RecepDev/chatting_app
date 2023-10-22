import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:chatting_app/widgets/chat_messages.dart';
import 'package:chatting_app/widgets/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sugar/sugar.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String sendedId = '';
  late String gelenId = '';
  String title = 'ChainChat';
  late String gelen;

  final _formKey = GlobalKey<FormState>();
  bool isChatPressed = true;
  final TextEditingController _controller = TextEditingController();

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void newChat(bool isOkeyChat) async {
    String enteredText = _controller.text;
    if (isOkeyChat == false) {
      return;
    } else {
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      FirebaseFirestore.instance
          .collection('chats')
          .doc(enteredText)
          .set({'owner': user.uid});
    }
  }

  @override
  Widget build(BuildContext context) {
    //  String enteredText = _controller.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                newChatCheck();
              });
            },
            icon: const Icon(Icons.add),
          ),
          
          
          IconButton(
            onPressed: () {
              showConfirmationDialog(context);
              //alertDialog();
            },
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isChatPressed)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isChatPressed == false) {
                      setState(() {
                        isChatPressed = true;
                        title = 'ChainChat';
                      });
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(218, 0, 0, 0),
                    ),
                  ),
                  child: const Text(
                    'Chats',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //ElevatedButton(child: const Text('asd'), onPressed: () {}),
              ],
            ),
          if (!isChatPressed)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ChatMessages(
                          messageId: sendedId,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (isChatPressed == false) {
                              setState(() {
                                isChatPressed = true;
                                title = 'ChainChat';
                              });
                            } else {
                              return;
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(218, 0, 0, 0),
                            ),
                          ),
                          child: const Text(
                            'Chats',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NewMessage(gelenId: gelenId),
                ],
              ),
            ),
          if (isChatPressed)
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('chats').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center();
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
                  //  List list = loadedChatsNames.toList();
                  //      print(list);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          onDismissed: (direction) {
                            deleteCheck(loadedChatsNames[index].id);
                          },
                          key: UniqueKey(),
                          child: Card(
                            key: const ValueKey('2'),
                            child: ListTile(
                              key: const ValueKey('2'),
                              leading: const Icon(Icons.chat),
                              title: Text(loadedChatsNames[index].id),
                              onTap: () {
                                setState(() {
                                  title = loadedChatsNames[index].id;
                                  gelenId = loadedChatsNames[index].id;
                                  sendedId = loadedChatsNames[index].id;
                                  isChatPressed = !isChatPressed;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
        ],
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are You Sure?',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool newChatCheck() {
    bool isconfirm = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            content: TextFormField(
              key: const ValueKey('name'),
              controller: _controller,
              // Other properties
            ),
            title: const Text(
              'New chat name?',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                key: const ValueKey('name'),
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                  newChat(isconfirm);
                  _controller.clear();
                },
              ),
            ],
          ),
        );
      },
    );
    return isconfirm;
  }

  void deleteChat(String silinecekChatismi) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(silinecekChatismi)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  void deleteCheck(String silinecekChatismi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are You Sure?',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await ownerCheck(silinecekChatismi).then((String value) {
                  setState(() {
                    gelen = value;
                  });

                  if (gelen == FirebaseAuth.instance.currentUser!.uid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('The chat is successfully deleted.'),
                      ),
                    );
                    setState(() {
                      deleteChat(silinecekChatismi);
                      Navigator.of(context).pop();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('This chat is not yours'),
                      ),
                    );
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> ownerCheck(String chatismi) async {
    var gelen = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatismi)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        return data['owner'].toString();
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return gelen;
  }
}
