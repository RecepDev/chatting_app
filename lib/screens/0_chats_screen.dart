import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '0.1_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sugar/sugar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late String owners;
  late String gonderilecekChatName;
  String title = 'ChainChat';
  late String gelenId = '';
  late String sendedId = '';
  late String voiceCallId = '';
  late String usernameforcall = '';
  late bool isGroupCheck;
  String? currentUserEmail;
  String? userUid;
  late List listWithoutMe = [];
  late List<ZegoUIKitUser> userList = [];
  List<dynamic> gonderilecekowners = [];
  String gonderilecekmail = '';
  int gonderilecekGroupNumber = 0;
  String gonderilecekGroupCreatorName = '';
  String gonderilecekCreatedAt = '';
  String gonderilecekdocID = '';
  String gonderilecekCreatorEmail = '';
  String gonderilecekToEmail = '';

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
        key: UniqueKey(),
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users', arrayContains: currentUserEmail)
            .orderBy('newTextTime', descending: true)
            .snapshots(),
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

          return ListView.builder(
            itemCount: loadedChatsNames.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              loadedChatsNames[index]['creatorEmail'];
              owners = loadedChatsNames[index]['creatorEmail'];
              return Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(right: 15, left: 12),
                  horizontalTitleGap: 12,
                  key: const ValueKey('2'),
                  leading: avatarCheck(loadedChatsNames, index),
                  subtitle: loadedChatsNames[index]['isEmpty']
                      ? gonder(loadedChatsNames, index)
                      : null,
                  trailing: SizedBox(
                    height: 30,
                    width: 54,
                    child: StreamBuilder<QuerySnapshot>(
                      key: UniqueKey(),
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(loadedChatsNames[index].id)
                          .collection('messages')
                          .orderBy('createdAt')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //   isEmpty = loadedChatsNames[index]['isEmpty'];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(''),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }
                        return Text(formatTimestamp(
                            snapshot.data!.docs.last['createdAt']));
                      },
                    ),
                  ),
                  title: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: pickTitle(loadedChatsNames, index)),
                  onTap: () {
                    gonderilecekChatName = loadedChatsNames[index].id;

                    // chatPressed = !chatPressed;
                    if (loadedChatsNames[index]['isGroup'] == false) {
                      gonderilecekCreatorEmail =
                          loadedChatsNames[index]['creatorEmail'];
                      gonderilecekToEmail = loadedChatsNames[index]['toEmail'];
                      gonderilecekowners = loadedChatsNames[index]['owner'];
                      gonderilecekdocID = loadedChatsNames[index].id;
                      gonderilecekCreatedAt = formatTimestamp2(
                          loadedChatsNames[index]['createdAt']);
                      gonderilecekmail = loadedChatsNames[index]['toEmail'];
                      voiceCallId = owners == currentUserEmail
                          ? loadedChatsNames[index]['tovoiceCallId']
                          : loadedChatsNames[index]['creatorVoiceCallId'];
                      usernameforcall = owners == currentUserEmail
                          ? loadedChatsNames[index]['toUsername']
                          : loadedChatsNames[index]['creatorUsername'];

                      title = owners == currentUserEmail
                          ? loadedChatsNames[index]['toUsername']
                          : loadedChatsNames[index]['creatorUsername'];
                      gelenId = loadedChatsNames[index].id;
                      sendedId = loadedChatsNames[index].id;
                      isGroupCheck = false;
                      debugPrint(sendedId);
                      userList.add(ZegoUIKitUser(
                          id: voiceCallId, name: usernameforcall));
                    } else {
                      gonderilecekCreatorEmail =
                          loadedChatsNames[index]['creatorEmail'];
                      gonderilecekToEmail = loadedChatsNames[index]['toEmail'];
                      gonderilecekowners = loadedChatsNames[index]['owner'];
                      gonderilecekdocID = loadedChatsNames[index].id;
                      gonderilecekCreatedAt = formatTimestamp2(
                          loadedChatsNames[index]['createdAt']);

                      gonderilecekGroupCreatorName =
                          loadedChatsNames[index]['creatorUsername'];
                      gonderilecekGroupNumber =
                          loadedChatsNames[index]['users'].length;
                      title = loadedChatsNames[index]['toUsername'];
                      sendedId = loadedChatsNames[index].id;
                      isGroupCheck = loadedChatsNames[index]['isGroup'];
                      Map<String, dynamic> maps =
                          loadedChatsNames[index]['usersMap'];

                      for (var userUids in loadedChatsNames[index]['owner']) {
                        listWithoutMe.add(userUids);
                        listWithoutMe.remove(userUid);

                        //print(userUids);
                      }
                      for (var listWithoutMe in listWithoutMe) {
                        userList.add(ZegoUIKitUser(
                            id: maps[listWithoutMe]['callerId'],
                            name: maps[listWithoutMe]['name']));
                      }
                    }

                    Navigator.push(
                        context,
                        PageTransition(
                            child: MessagesScreen(
                              creatorEmail: gonderilecekCreatorEmail,
                              owners: gonderilecekowners,
                              toEmail: gonderilecekToEmail,
                              docID: gonderilecekdocID,
                              createdAt: gonderilecekCreatedAt,
                              creatorName: gonderilecekGroupCreatorName,
                              groupNumber: gonderilecekGroupNumber,
                              gelenAvatar: avatarCheck(loadedChatsNames, index),
                              userList: userList,
                              isGroup: isGroupCheck,
                              title: title,
                              sendedId: sendedId,
                              gonderilecekChatName: gonderilecekChatName,
                              mail: gonderilecekmail,
                            ),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 100)));
                    listWithoutMe.clear();

                    // _tabController;
                  },
                ),
              );
            },
          );
        });
  }

  CircleAvatar avatarCheck(
      List<QueryDocumentSnapshot<Object?>> loadedChatsNames, int index) {
    bool isGroup = loadedChatsNames[index]['isGroup'];
    if (isGroup) {
      return CircleAvatar(
        radius: 24,
        backgroundImage:
            NetworkImage(loadedChatsNames[index]['creatorImageUrl']),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: loadedChatsNames[index]['toEmail'] != currentUserEmail
            ? NetworkImage(loadedChatsNames[index]['toimageUrl'])
            : NetworkImage(loadedChatsNames[index]['creatorImageUrl']),
        backgroundColor: Colors.black,
      );
    }
  }

  Widget gonder(loadedChatsNames, index) {
    return SizedBox(
      height: 18,
      width: 50,
      child: StreamBuilder<QuerySnapshot>(
        key: UniqueKey(),
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(loadedChatsNames[index].id)
            .collection('messages')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container();
          }
          if (snapshot.hasError) {
            return Container();
          }
          return Text(
              // ignore: unused_result
              '${'${snapshot.data!.docs.last['username']}'.capitalize()}: ${snapshot.data!.docs.last['text']}');
        },
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('d/M/yy'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

  String formatTimestamp2(Timestamp timestamp) {
    var format = DateFormat('d/M/y'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

  Widget pickTitle(
      List<QueryDocumentSnapshot<Object?>> loadedChatsNames, int index) {
    if (loadedChatsNames[index]['isGroup']) {
      return Text(loadedChatsNames[index]['toUsername'],
          style: const TextStyle(fontSize: 17));
    } else {
      if (owners == currentUserEmail) {
        return Text(
          '${loadedChatsNames[index]['toUsername']}'.capitalize(),
          style: const TextStyle(fontSize: 17),
        );
      } else {
        return Text(
          '${loadedChatsNames[index]['creatorUsername']}'.capitalize(),
          style: const TextStyle(fontSize: 17),
        );
      }
    }
  }
}
