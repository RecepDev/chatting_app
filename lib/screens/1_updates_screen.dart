import 'dart:io';

import 'package:chatting_app/screens/my_updates.dart';
import 'package:chatting_app/screens/1.1_updates_detail_screen.dart';
import 'package:chatting_app/screens/updates_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sugar/sugar.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

List<dynamic> kontrolList = [];
List<String> userUidList = [];
List<dynamic> list = [];
List idList = [];
File? _pickedImageFile;
List<String> urls = [];
bool isShown = true;
String? currentUserEmail;
String? userUid;
List<String> urlss = [];
/* 
CallerIdNotifier? userProvider; */

bool isDropDownPressed = false;
String formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays} days ago';
  } else if (duration.inHours > 0) {
    return '${duration.inHours} hours ago';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  /*  @override
  void initState() {
    super.initState();
    getMyUpdates().then((value) {
      urlss = value;
    });
  } */

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    /* 
    userProvider = Provider.of<CallerIdNotifier>(context, listen: true); */

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.06,
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Status',
                          style: TextStyle(fontSize: 20),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: PopupMenuButton(
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
                                      'Muted updates         ',
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
                                      'Status privacy',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                          onSelected: (index) async {
                            switch (index) {
                              case 'report':
                                // showDialog(
                                //     barrierDismissible: true,
                                //     context: context,
                                //     builder: (context) => ReportUser(
                                //       currentUser: widget.sender,
                                //       seconduser: widget.second,
                                //     )).then((value) => Navigator.pop(ct))
                                break;
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: currentUserEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
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

                    /*  for (int i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    //  debugPrint(Uid);
                                    userCheck(user);
                                  }  */
                    debugPrint('${snapshot.data!.docs.length}');

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
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

                        kontrolList = snapshot.data!.docs[index]['photos'];
                        return ListTile(
                          horizontalTitleGap: 8,
                          minLeadingWidth: 10,
                          contentPadding:
                              const EdgeInsets.only(left: 12, right: 12),
                          onTap: () {
                            if (kontrolList.isEmpty) {
                              _pickImage();
                            } else {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: MyUpdatesScreen(
                                        list: kontrolList,
                                      ),
                                      type: PageTransitionType.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 100)));

                              /*     Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => )); */

                              /* Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        UpdatesScreen(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['username'],
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['image_url'],
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['email'],
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['photos']))); */
                            }
                          },
                          leading: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 5),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: snapshot.data!
                                          .docs[index]['photos'].isNotEmpty
                                      ? Colors.green
                                      : null,
                                  child: CircleAvatar(
                                    radius: 23,
                                    backgroundImage: NetworkImage(snapshot
                                        .data!.docs[index]['image_url']),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: SizedBox(
                                  height: 23,
                                  width: 23,
                                  child: snapshot
                                          .data!.docs[index]['photos'].isEmpty
                                      ? const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.add,
                                              size: 20, color: Colors.black))
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          title: const Text(
                            'My status',
                            style: TextStyle(fontSize: 17),
                          ),
                          subtitle: snapshot.data!.docs[index]['photos'].isEmpty
                              ? const Text('Tap to add status update')
                              : Text(formattedTimeDifference),
                        );
                      },
                    );
                  }),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('hasUpdate', isEqualTo: true)
                  .where('whoWillSee', arrayContains: currentUserEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center();
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const SizedBox();
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                /*  if (snapshot.data!.docs[0]['hasUpdate'] == true || snapshot.data!.docs[0]['hasUpdate'] == false ) {
                               
                            
                            } */
                /*  for (int i = 0;
                              i < snapshot.data!.docs.length;
                              i++) {
                            
                          } */

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.02,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Recent updates',
                            style: TextStyle(fontSize: 14),
                          )),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        /*  
                                    if (snapshot.data!.docs.isEmpty ) {
                                        Future.delayed(const Duration(seconds: 0), () {
                                          setState(() {
                                            isThereUpdatesany = false;
                                          });
                                        });
                                    } */

                        Timestamp datetime =
                            snapshot.data!.docs[index]['lastUpdatePhoto'];
                        int datetime1 = datetime.millisecondsSinceEpoch;
                        DateTime dateTime1 =
                            DateTime.fromMillisecondsSinceEpoch(datetime1);
                        Duration difference =
                            DateTime.now().difference(dateTime1);

                        String formattedTimeDifference =
                            formatDuration(difference);
                        /* photoList =
                                          snapshot.data!.docs[index]['photos']; */
                        //  debugPrint('${photoList}11111111111');
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          userUidList
                              .add(snapshot.data!.docs[index]['UserUid']);
                        }

                        /* for (int i = 0;
                                          i < snapshot.data!.docs.length;
                                          i++) {
                                        /* for (String Uid in userUidList) {
                                          debugPrint(Uid);
                                          deneme2(Uid);
                                          
                                        } */
                                      } */

                        //  intt = ;

                        /*  deneme(snapshot.data!.docs[index]['UserUid'])
                                          .then((value) {
                                        denemeList = value;
                                      }); */
                        //   List listt = photoList[index];

                        // check = photoList.isEmpty;

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
                                    ? Colors.green
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
                  ],
                );
              },
            ),
            const StatusUpdatesFromOtherUsers(),
          ],
        ),
        /* Positioned(
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
                              _pickImage();
                            },
                            icon: const Icon(Icons.camera_alt,
                                size: 30, color: Colors.white),
                          ),
                        ),
                      ), */
      ],
    );
  }

  void _pickImage() async {
    var isImagePicked = false;

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    var data = await FirebaseFirestore.instance.collection('users').get();

    for (QueryDocumentSnapshot dd in data.docs) {
      if (dd['email'] == currentUserEmail) {
      } else {
        idList.add(dd['email']);
      }
    }

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      isImagePicked = true;
    });
    //widget.onPickImage(_pickedImageFile!);
    if (isImagePicked) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('update_images')
          .child(userUid!)
          .child('${DateTime.now()}.jpeg');
      final storageRef2 =
          FirebaseStorage.instance.ref().child('update_images').child(userUid!);

      storageRef2.getDownloadURL().then((url) => urls.add(url.toString()));
      await storageRef.putFile(_pickedImageFile!);
      //  await storageRef2.then((value) {
      //   imageUrl.add(value);
      //});

      FirebaseStorage storage = FirebaseStorage.instance;
      // Klasördeki tüm dosyaların referanslarını alın
      ListResult result =
          await storage.ref('/update_images/$userUid').listAll();

      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();

        urls.add(downloadURL);
      }

      FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'hasUpdate': true,
        'photos': urls,
        'lastUpdatePhoto': DateTime.now(),
        'whoWillSee': idList,
        'whoCheck': [],
      }).then((value) {
        urls = [];
        idList = [];
      });
    }
  }
}
