// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/model/user_database_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.localUserId,
    required this.myImageUrl,
    required this.myName,
    required this.myEmail,
    required this.myVoiceCallId,
  });
  final String localUserId;
  final String myImageUrl;
  final String myName;
  final String myEmail;
  final String myVoiceCallId;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();

class _CallScreenState extends State<CallScreen> {
  late String gonderilecekUid;
  Map<String, bool?> selectionMap = {};
  List<String> selectionMapOfId = [];
  final _form = GlobalKey<FormState>();
  List eklenecekUserlar = [];
  List<dynamic> usersArray = [];
  int contactsLength = 0;
  String? user;
  final userDatabaseProvider = UserDatabaseProvider();

  @override
  Widget build(BuildContext context) {
    contactsLength =
        Provider.of<CallerIdNotifier>(context, listen: true).getcontact;

    user = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '$contactsLength contacts',
              style: const TextStyle(fontSize: 13, color: Colors.white),
            )
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.90,
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'New call link',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {},
                      leading: const Icon(Icons.group),
                    ),
                    ListTile(
                      title: const Text(
                        'New group call',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {},
                      leading: const Icon(Icons.group_add),
                    ),
                    ListTile(
                      title: const Text(
                        'New contact',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {},
                      leading: const Icon(Icons.groups),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email', isNotEqualTo: user)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                // isSelectedList =
                                //   List.filled(snapshot.data!.docs.length, false);

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center();
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                    child: Text('No messages found.'),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text('Something went wrong'),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Provider.of<CallerIdNotifier>(context,
                                            listen: false)
                                        .changeContactslength(
                                            snapshot.data!.docs.length);
                                    gonderilecekUid =
                                        snapshot.data!.docs[index]['UserUid'];
                                    selectionMap[
                                            '${snapshot.data!.docs[index]['email']}'] =
                                        selectionMap[
                                                '${snapshot.data!.docs[index]['email']}'] ??
                                            false;
                                    return ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          right: 0, left: 16),
                                      selected: selectionMap[
                                          '${snapshot.data!.docs[index]['email']}']!,
                                      onTap: () {},
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot
                                            .data!.docs[index]['image_url']),
                                      ),
                                      title: user ==
                                              snapshot.data!.docs[index]
                                                  ['email']
                                          ? const Text('Ben')
                                          : Text(snapshot.data!.docs[index]
                                              ['username']),
                                      subtitle: Text(
                                          snapshot.data!.docs[index]['email']),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          spacing: 10,
                                          children: [
                                            actionButton(
                                                false,
                                                snapshot.data!.docs[index]
                                                    ['voiceCallId'],
                                                snapshot.data!.docs[index]
                                                    ['username'],
                                                context),
                                            actionButton(
                                                true,
                                                snapshot.data!.docs[index]
                                                    ['voiceCallId'],
                                                snapshot.data!.docs[index]
                                                    ['username'],
                                                context),
                                            /* IconButton(
                                                onPressed: () {
                                                  actionButton(
                                                      false,
                                                      snapshot.data!.docs[index]
                                                          ['voiceCallId'],
                                                      snapshot.data!.docs[index]
                                                          ['username']);
                                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  //     return CallPage(callID: snapshot.data!.docs[index]
                                                  // ['voiceCallId'], userName: '${user}_${widget.localUserId}',);
                                                  //},));
                                                },
                                                icon: Icon(
                                                  Icons.call,
                                                  size: 26,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  actionButton(
                                                      true,
                                                      snapshot.data!.docs[index]
                                                          ['voiceCallId'],
                                                      snapshot.data!.docs[index]
                                                          ['username']);
                                                },
                                                icon: Icon(
                                                  Icons.video_call,
                                                  size: 26,
                                                )), */
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(
      bool isVideo, String gelenId, String gelenName, BuildContext ctx) {
    bool onceWork = true;

    if (onceWork) {
      userDatabaseProvider.initialize().then((value) {
        userDatabaseProvider.createTable(userDatabaseProvider.database!);
        onceWork = false;
      });
    }

    return ZegoSendCallInvitationButton(
        buttonSize: const Size(44, 44),
        iconSize: const Size(44, 44),
        customData: 'false',
        callID: isVideo == true
            ? 'ZegoCallType.videoCall'
            : 'ZegoCallType.voiceCall',
        icon: isVideo
            ? ButtonIcon(icon: const Icon(Icons.video_call))
            : ButtonIcon(icon: const Icon(Icons.call)),
        resourceID: 'aaabbb',
        invitees: [ZegoUIKitUser(id: gelenId, name: gelenName)],
        isVideoCall: isVideo);
  }
}
