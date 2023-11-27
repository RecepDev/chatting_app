import 'dart:ffi';
import 'dart:io';

import 'package:chatting_app/screens/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

class SelectGroupMembers extends StatefulWidget {
  const SelectGroupMembers({super.key});

  @override
  State<SelectGroupMembers> createState() => _SelectGroupMembersState();
}

class _SelectGroupMembersState extends State<SelectGroupMembers> {
  late String gonderilecekUid;
  Map<String, bool?> selectionMap = {};
  List<String> selectionMapOfId = [];
  final _form = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  List eklenecekUserlar = [];
  List<dynamic> usersArray = [];
  Map<String, Map<String, dynamic>> users = {};
  List<Array> array = [];
  String cacheusername = '';
  String cacheemail = '';
  String cacheimageurl = '';
  String cachevoiceCallId = '';
  String cacheUserUid = '';
  String? currentUserEmail;

  void newChat(bool isOkeyChat) async {
    String enteredText = _messageController.text;
    if (isOkeyChat == false) {
      return;
    } else {
      final user = FirebaseAuth.instance.currentUser!;

      FirebaseFirestore.instance
          .collection('chats')
          .doc(enteredText)
          .set({'owner': user.uid});
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      cacheusername = value['username'];
      cacheemail = value['email'];
      cacheimageurl = value['image_url'];
      cachevoiceCallId = value['voiceCallId'];
      cacheUserUid = value['UserUid'];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    // List<bool> isSelectedList = [];

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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New group',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Add participants',
              style: TextStyle(fontSize: 13, color: Colors.white),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.88,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
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
                                    .where('email',
                                        isNotEqualTo: currentUserEmail)
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
                                      gonderilecekUid =
                                          snapshot.data!.docs[index]['UserUid'];
                                      selectionMap[
                                              '${snapshot.data!.docs[index]['email']}'] =
                                          selectionMap[
                                                  '${snapshot.data!.docs[index]['email']}'] ??
                                              false;
                                      return ListTile(
                                        selected: selectionMap[
                                            '${snapshot.data!.docs[index]['email']}']!,
                                        onTap: () {
                                          setState(() {
                                            String eklenecekUidler = snapshot
                                                .data!.docs[index]['UserUid'];
                                            if (selectionMapOfId
                                                .contains(eklenecekUidler)) {
                                              selectionMapOfId
                                                  .remove(eklenecekUidler);
                                            } else {
                                              selectionMapOfId.add(
                                                  eklenecekUidler.toString());
                                            }

                                            if (users
                                                .containsKey(eklenecekUidler)) {
                                              users.remove(eklenecekUidler);
                                            } else {
                                              users[snapshot.data!.docs[index]
                                                  ['UserUid']] = {
                                                'name': snapshot.data!
                                                    .docs[index]['username'],
                                                'uid': snapshot.data!
                                                    .docs[index]['UserUid'],
                                                'email': snapshot
                                                    .data!.docs[index]['email'],
                                                'callerId': snapshot.data!
                                                    .docs[index]['voiceCallId'],
                                                'imageUrl': snapshot.data!
                                                    .docs[index]['image_url']
                                              };

                                              users.addAll({
                                                cacheUserUid: {
                                                  'name': cacheusername,
                                                  'uid': cacheUserUid,
                                                  'email': cacheemail,
                                                  'callerId': cachevoiceCallId,
                                                  'imageUrl': cacheimageurl,
                                                }
                                              });
                                            }

                                            eklenecekUserlar.add(snapshot
                                                .data!.docs[index]['email']);

                                            //  selectionMap.addAll({'${snapshot.data!.docs[index]['email']}' : true});

                                            selectionMap[
                                                    '${snapshot.data!.docs[index]['email']}'] =
                                                !selectionMap[
                                                    '${snapshot.data!.docs[index]['email']}']!;
                                            if (usersArray.contains(snapshot
                                                .data!.docs[index]['email'])) {
                                              usersArray.remove(snapshot
                                                  .data!.docs[index]['email']);
                                            } else {
                                              usersArray.add(snapshot
                                                  .data!.docs[index]['email']);
                                            }
                                          });
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data!.docs[index]['image_url']),
                                        ),
                                        title: currentUserEmail ==
                                                snapshot.data!.docs[index]
                                                    ['email']
                                            ? const Text('Ben')
                                            : Text(snapshot.data!.docs[index]
                                                ['username']),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]['email']),
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
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 11,
                    spreadRadius: 1,
                    color: Colors.grey.shade600,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                iconSize: 55,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: CreateGroup(
                            gelenGrupUyeleri: usersArray,
                            selectionMapOfId: selectionMapOfId,
                            gelenMap: users,
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200)));
                  /* Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => )); */
                },
                icon: const Icon(Icons.arrow_forward,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
