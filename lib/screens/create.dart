import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/screens/0.1_message_screen.dart';
import 'package:chatting_app/screens/select_users_forgroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CreateChat extends StatefulWidget {
  final String optionalData;

  final Function(BuildContext) callback;

  const CreateChat(this.callback, this.optionalData, {super.key});

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  late String gidecekUniqueId;

  bool isMe = false;
  List<String> myArray2 = [];
  late List<dynamic> list;
  late String random = '';
  late List<ZegoUIKitUser> userList = [];
  String? currentUserEmail;
  String? userUid;

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leadingWidth: 50,
        titleSpacing: 1,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          PopupMenuButton(
            shadowColor: Colors.grey.shade600,
            icon: const Icon(Icons.more_vert,
                color: Colors.white), // add this line
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
                onTap: () {
                  widget.callback(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          )
        ],
        title: const Text(
          'New Group or Chat',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              'New Group',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const SelectGroupMembers(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 200)));
              /*  Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => SelecetGroupMembers()))); */
            },
            leading: const Icon(Icons.group),
          ),
          ListTile(
            title: const Text(
              'New Contact',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {},
            leading: const Icon(Icons.group_add),
          ),
          ListTile(
            title: const Text(
              'New community',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {},
            leading: const Icon(Icons.groups),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 10,
            ),
            child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Users on ChainChat',
                  style: TextStyle(fontSize: 15),
                )),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('email', isNotEqualTo: currentUserEmail)
                .snapshots(),
            builder: (context, snapshot) {
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

              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //  itemCount = snapshot.data!.docs.length;
                    //   toNewGroupUserName = snapshot.data!.docs[index]['username'];
                    //  toNewGroupImageUrl =snapshot.data!.docs[index]['image_url'];
                    //   toNewGroupMail = snapshot.data!.docs[index]['email'];

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userUid)
                        .get()
                        .then((value) {
                      list = value['talks'];
                      debugPrint(list.toString());
                    });
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, top: 0),
                      child: ListTile(
                        onTap: () {
                          if (currentUserEmail ==
                                  snapshot.data!.docs[index]['email'] ||
                              list.contains(
                                  snapshot.data!.docs[index]['email'])) {
                            return;
                          } else {
                            _submit(
                              snapshot.data!.docs[index]['username'],
                              snapshot.data!.docs[index]['image_url'],
                              snapshot.data!.docs[index]['UserUid'],
                              snapshot.data!.docs[index]['email'],
                              snapshot.data!.docs[index]['voiceCallId'],
                            );
                            myArray2 = [snapshot.data!.docs[index]['email']];

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(snapshot.data!.docs[index]['UserUid'])
                                .update({
                              'talks': [currentUserEmail],
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userUid)
                                .update({
                              'talks': FieldValue.arrayUnion(myArray2),
                            });

                            userList.add(ZegoUIKitUser(
                                id: snapshot.data!.docs[index]['voiceCallId'],
                                name: snapshot.data!.docs[index]['username']));
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: MessagesScreen(
                                      creatorEmail: currentUserEmail!,
                                      owners: [currentUserEmail],
                                      toEmail: snapshot.data!.docs[index]
                                          ['email'],
                                      docID: 'asdas',
                                      createdAt: DateTime.now().toString(),
                                      creatorName: 'bla bla',
                                      groupNumber: 1,
                                      mail: snapshot.data!.docs[index]['email'],
                                      gelenAvatar: avatarCheck(
                                          snapshot.data!.docs, index),
                                      userList: userList,
                                      isGroup: false,
                                      title: snapshot.data!.docs[index]
                                          ['username'],
                                      sendedId: random,
                                      gonderilecekChatName: random,
                                    ),
                                    type: PageTransitionType.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 100)),
                                ModalRoute.withName('/'));
                          }
                        },
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['image_url']),
                        ),
                        title: currentUserEmail ==
                                snapshot.data!.docs[index]['email']
                            ? const Text('Ben')
                            : Text(snapshot.data!.docs[index]['username']),
                        subtitle: Text(snapshot.data!.docs[index]['email']),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _submit(String isim, imageUrl, gelenUniqueId, String email,
      String voiceCallId) async {
    random = const Uuid().v4();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String userMail = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot mydocs = await FirebaseFirestore.instance
        .collection('users')
        .where('UserUid', isEqualTo: userId)
        .get();

    List<String> myArray = [
      userMail,
      email,
    ];

    try {
      FirebaseFirestore.instance.collection('chats').doc(random).set({
        'isGroup': false,
        'isEmpty': false,
        'creatorImageUrl': mydocs.docs[0]['image_url'],
        'creatorUsername': mydocs.docs[0]['username'],
        'creatorEmail': mydocs.docs[0]['email'],
        'creatorId': mydocs.docs[0]['UserUid'],
        'creatorVoiceCallId': mydocs.docs[0]['voiceCallId'],
        'users': myArray,
        'toEmail': email,
        'toUsername': isim,
        'toimageUrl': imageUrl,
        'tovoiceCallId': voiceCallId,
        'owner': [userId, gelenUniqueId],
        'newTextTime': DateTime.now(),
        'createdAt': DateTime.now(),
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  CircleAvatar avatarCheck(
      List<QueryDocumentSnapshot<Object?>> loadedChatsNames, int index) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(loadedChatsNames[index]['image_url']),
      backgroundColor: Colors.black,
    );
  }
}
