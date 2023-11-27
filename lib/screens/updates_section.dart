// ignore_for_file: must_be_immutable

import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/screens/1.1_updates_detail_screen.dart';
import 'package:chatting_app/screens/1_updates_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar/sugar.dart';

class StatusUpdatesFromOtherUsers extends StatefulWidget {
  const StatusUpdatesFromOtherUsers({super.key});

  @override
  State<StatusUpdatesFromOtherUsers> createState() =>
      _StatusUpdatesFromOtherUsersState();
}

class _StatusUpdatesFromOtherUsersState
    extends State<StatusUpdatesFromOtherUsers> {
  bool isDropDownPressed = false;
  String? currentUserEmail;
  String? userUid;

  bool check = false;

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    isDropDownPressed =
        Provider.of<CallerIdNotifier>(context, listen: true).getDropDown;
    return Column(
      children: [
        SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('whoCheck', arrayContains: currentUserEmail)
                .where('hasUpdate', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11, right: 11),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<CallerIdNotifier>(context, listen: false)
                            .changeDropDownBool(!check);
                        check = !check;
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Viewed updates',
                              style: TextStyle(fontSize: 14),
                            ),
                            isDropDownPressed
                                // ignore: dead_code
                                ? const Icon(
                                    Icons.arrow_upward,
                                    size: 15,
                                  )
                                : const Icon(
                                    Icons.arrow_downward,
                                    size: 15,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isDropDownPressed,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Timestamp datetime =
                            snapshot.data!.docs[index]['lastUpdatePhoto'];
                        int datetime1 = datetime.millisecondsSinceEpoch;
                        DateTime dateTime1 =
                            DateTime.fromMillisecondsSinceEpoch(datetime1);
                        Duration difference =
                            DateTime.now().difference(dateTime1);

                        String formattedTimeDifference =
                            formatDuration(difference);

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userUid)
                            .get()
                            .then((value) {
                          list = value['talks'];
                        });
                        return ListTile(
                          horizontalTitleGap: 12,
                          contentPadding:
                              const EdgeInsets.only(left: 12, right: 12),
                          onTap: () {
                            /*  deneme(
                                        snapshot.data!.docs[index]['UserUid'],
                                        snapshot,
                                        index); */
                            if (snapshot.data!.docs[index]['photos'].isEmpty) {
                              return;
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => UpdatesDetailScreen(
                                      snapshot.data!.docs[index]['username'],
                                      snapshot.data!.docs[index]['image_url'],
                                      snapshot.data!.docs[index]['email'],
                                      snapshot.data!.docs[index]['photos'],
                                      formattedTimeDifference,
                                      snapshot,
                                      index,
                                      snapshot.data!.docs[index]['UserUid'])));
                            }
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                snapshot.data!.docs[index]['photos'].isNotEmpty
                                    ? Colors.grey
                                    : null,
                            child: CircleAvatar(
                              radius: 23,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['image_url']),
                            ),
                          ),
                          title: currentUserEmail ==
                                  snapshot.data!.docs[index]['email']
                              ? const Text('Ben')
                              : Text(
                                  '${snapshot.data!.docs[index]['username']}'
                                      .capitalize(),
                                  style: const TextStyle(fontSize: 17),
                                ),
                          subtitle: Text(formattedTimeDifference),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
