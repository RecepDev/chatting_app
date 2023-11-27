import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sugar/sugar.dart' as ddd;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatDetailScreen extends StatefulWidget {
  ChatDetailScreen({
    super.key,
    //required this.chatImage,
    required this.chatName,
    required this.gelenAvatar,
    required this.voiceCall,
    required this.videoCall,
    required this.userMail,
    required this.isGroup,
    required this.groupNumber,
    required this.creatoreName,
    required this.createdAt,
    required this.docID,
    required this.creatorEmail,
    required this.toEmail,
    required this.owners,
  });

  // String chatImage;
  String chatName;
  String docID;
  CircleAvatar gelenAvatar;
  String userMail;
  String createdAt;
  int groupNumber;
  String creatoreName;
  bool isGroup;
  String creatorEmail;
  String toEmail;
  List<dynamic> owners;
  ZegoSendCallInvitationButton voiceCall;
  ZegoSendCallInvitationButton videoCall;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

ScrollController? controller;
double maxpadding = 103;
double padding = 0;
String tag = 'tag1';
bool isVisible = true;
double imageWidth = 0;
double imageHeight = 0;
double imageLeftPadding = 0;
Color color = Colors.grey;
List listt = [];
late List<dynamic> gelen;
String? currentUserEmail;
bool switchBool = false;

SystemUiOverlayStyle value = SystemUiOverlayStyle.dark;
bool firstWork = true;

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    //maxpadding = MediaQuery.sizeOf(context).width / 2;
    /*   _tabController.animation?.addListener(() {
      Provider.of<CallerIdNotifier>(context, listen: false)
          .changeTabindex((_tabController.animation!.value).round());
    }); */

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller!.addListener(() {
          if (controller!.offset.round().toDouble() > 150) {
            /*  Provider.of<CallerIdNotifier>(context, listen: false)
                .changeBoolIsVisible(true);
              Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImageWidth(60);
             Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImagePadding2(35);
             Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImagePadding(0);
              Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImageHeight(40); 
            */
            tag = 'a';
            color = Colors.white;
            value = SystemUiOverlayStyle.light;
          }

          /* if (controller!.offset.round().toDouble() > 122) {
            Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImageHeight(controller!.offset.round().toDouble() - 50);
          } */

          // print('${controller!.offset.round().toDouble()} GERÇEK OFFSET');
          if (controller!.offset.round().toDouble() < maxpadding) {
            /* Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImagePadding(
                    maxpadding - controller!.offset.round().toDouble()); */

            if (maxpadding - controller!.offset.round().toDouble() < 30) {
              //    print('----------------2. yer------------- çalişti');
              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeBoolIsVisible(true);
              /*    
              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImageWidth(60);
              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImagePadding2(35);

              /*  Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImageHeight(50); */
              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImagePadding(0); */
              tag = 'a';
              color = Colors.white;
              value = SystemUiOverlayStyle.light;
            } else {
              //  print('----------------3. yer------------- çalişti');
              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeBoolIsVisible(false);
              /*  Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImageWidth(125);

              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImagePadding2(0);

              Provider.of<CallerIdNotifier>(context, listen: false)
                  .changeImageHeight(125); */
              tag = 'tag1';
              color = Colors.grey;
              value = SystemUiOverlayStyle.dark;
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    isVisible =
        Provider.of<CallerIdNotifier>(context, listen: true).getisVisible;

    return WillPopScope(
      onWillPop: () async {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            Provider.of<CallerIdNotifier>(context, listen: false)
                .changeBoolIsVisible(false);
            /* Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImageWidth(125);
            Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImagePadding(125);
            Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImagePadding2(0);

            Provider.of<CallerIdNotifier>(context, listen: false)
                .changeImageHeight(125); */

            Future.delayed(const Duration(seconds: 0), () {
              color = Colors.grey;
              value = SystemUiOverlayStyle.dark;
              listt.clear();
              //  print('silinmiş olmasi gereken liste $listt');
            });

            //Navigator.of(context).maybePop();
          },
        );
        Navigator.pop(context);

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(225, 245, 245, 245),
        body: CustomScrollView(
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          physics: const ClampingScrollPhysics(),
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: value,
              backgroundColor: Theme.of(context).colorScheme.primary,
              titleSpacing: 25,
              leading: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<CallerIdNotifier>(context, listen: false)
                          .changeBoolIsVisible(false);
                      /*  Provider.of<CallerIdNotifier>(context, listen: false)
                          .changeImageWidth(125);
                      Provider.of<CallerIdNotifier>(context, listen: false)
                          .changeImageHeight(125);
                      Provider.of<CallerIdNotifier>(context, listen: false)
                          .changeImagePadding(103);
                      Provider.of<CallerIdNotifier>(context, listen: false)
                          .changeImagePadding2(0); */
                      Future.delayed(const Duration(seconds: 0), () {
                        color = Colors.grey;
                        value = SystemUiOverlayStyle.dark;
                        firstWork = true;
                        listt.clear();
                        //   print('silinmiş olmasi gereken liste $listt');
                      });

                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              pinned: true,
              actions: [
                PopupMenuButton(
                    shadowColor: Colors.white,
                    icon: Icon(Icons.more_vert, color: color), // add this line
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            padding: const EdgeInsets.all(1),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Change group name',
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
                    })
              ],
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 5,
                //collapseMode: CollapseMode.parallax,

                titlePadding: const EdgeInsets.only(
                    left: 29, top: 45, bottom: 8, right: 0),
                title: Padding(
                  padding: const EdgeInsets.only(left: 16.5),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Hero(
                        tag: tag,
                        child: SizedBox(
                          height: 40,
                          width: 37,
                          child: FittedBox(
                            child: widget.gelenAvatar,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Visibility(
                            visible: isVisible,
                            child: Text(
                              widget.chatName,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  color: Colors.white,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.chatName,
                                  style: const TextStyle(fontSize: 39),
                                ),
                                if (widget.isGroup)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10,
                                            right: 4,
                                            left: 8.0,
                                            top: 1),
                                        child: Text(
                                          'Group',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10,
                                            right: 8.0,
                                            left: 4,
                                            top: 1),
                                        child: Text(
                                          '${widget.groupNumber} participants',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                if (!widget.isGroup)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10,
                                        right: 4,
                                        left: 8.0,
                                        top: 1),
                                    child: Text(
                                      widget.userMail,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 0.0, right: 8.0, left: 8.0, top: 0),
                              child: SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      widget.voiceCall,
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Audio',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 37, left: 37),
                                      child: Column(children: [
                                        widget.videoCall,
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Video',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        )
                                      ]),
                                    ),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: Icon(
                                          Icons.search,
                                          size: 39,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Search',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.isGroup)
                                Text(
                                  'Add group description',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              if (widget.isGroup)
                                const SizedBox(
                                  height: 6,
                                ),
                              if (widget.isGroup)
                                Text(
                                    'Created by ${widget.creatoreName} ${widget.createdAt}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 14, top: 14, left: 14, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Media, links, and docs'),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Gölge rengi ve opaklık
                                              spreadRadius:
                                                  5, // Yayılma yarıçapı
                                              blurRadius:
                                                  7, // Bulanıklık yarıçapı
                                              offset: const Offset(0,
                                                  3), // Gölgenin konumu (x, y)
                                            ),
                                          ],
                                        ),
                                        height: 75,
                                        child: Image.network(
                                            'https://picsum.photos/200'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                  top: 0,
                                  right: 10,
                                  bottom: 0,
                                  left: 16,
                                ),
                                title: const Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Mute notifications'),
                                trailing: Switch(
                                  trackOutlineWidth:
                                      const MaterialStatePropertyAll(1),
                                  value: switchBool,
                                  onChanged: (value) {
                                    setState(() {
                                      switchBool = value;
                                    });
                                  },
                                ),
                                leading: const Icon(Icons.notifications)),
                            const ListTile(
                                title: Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Custom notification'),
                                leading: Icon(Icons.music_note)),
                            const ListTile(
                                title: Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Media visibility'),
                                leading: Icon(Icons.image)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        child: const Column(
                          children: [
                            ListTile(
                                title: Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Encryption'),
                                subtitle: Text(
                                    'Messages and calls are end-to-end encrypted. Tap to learn more.'),
                                leading: Icon(Icons.enhanced_encryption)),
                            ListTile(
                                title: Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Disappearing messages'),
                                subtitle: Text('Off'),
                                leading: Icon(Icons.timelapse)),
                            ListTile(
                                title: Text(
                                    style: TextStyle(fontSize: 16.5),
                                    'Chat lock'),
                                leading: Icon(Icons.lock)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    if (widget.isGroup)
                      Material(
                        elevation: 1,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, left: 14, top: 8, bottom: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${widget.groupNumber} participants'),
                                    const Icon(Icons.search)
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.docID)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text('wrong'),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('Something went wrong'),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0.0),
                                      cacheExtent: 0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          snapshot.data!['usersMap'].length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> list =
                                            snapshot.data!['usersMap'];
                                        for (String element in list.keys) {
                                          if (listt.length == list.length) {
                                            // print('LİSTE EŞİT ');
                                          } else {
                                            //  print('listeye $element eklendi ');
                                            listt.add(element);
                                          }
                                        }
                                        // print(listt[index]);
                                        return ListTile(
                                          title: Text(
                                            '${list[listt[index]]['name']}'
                                                .capitalize(),
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                          subtitle:
                                              Text(list[listt[index]]['email']),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                list[listt[index]]['imageUrl']),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    if (widget.isGroup)
                      const SizedBox(
                        height: 7,
                      ),
                    Material(
                      elevation: 1,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            if (!widget.isGroup)
                              ListTile(
                                  onTap: () {
                                    deleteCheck(widget.docID, widget.owners,
                                        widget.creatorEmail, widget.toEmail);
                                  },
                                  title: Text(
                                    'Block ${widget.chatName}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  leading: const Icon(
                                    Icons.exit_to_app,
                                    color: Colors.red,
                                  )),
                            if (!widget.isGroup)
                              ListTile(
                                  title: Text(
                                    'Report ${widget.chatName}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  leading: const Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                  )),
                            if (widget.isGroup)
                              ListTile(
                                  onTap: () {
                                    deleteCheck(widget.docID, widget.owners,
                                        widget.creatorEmail, widget.toEmail);
                                  },
                                  title: const Text(
                                    'Exit group',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  leading: const Icon(
                                    Icons.exit_to_app,
                                    color: Colors.red,
                                  )),
                            if (widget.isGroup)
                              const ListTile(
                                  title: Text(
                                    'Report group',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  leading: Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                  )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void deleteChat(String silinecekChatismi, List<dynamic> silinecekIdler,
      String creatorEmail, String toEmail) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(silinecekIdler[1]);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> array = documentSnapshot['talks'];
    array.remove(creatorEmail);
    documentReference.update({'talks': array});

    DocumentReference documentReference2 =
        FirebaseFirestore.instance.collection('users').doc(silinecekIdler[0]);
    DocumentSnapshot documentSnapshot2 = await documentReference2.get();
    List<dynamic> array2 = documentSnapshot2['talks'];
    array2.remove(toEmail);
    documentReference2.update({'talks': array2});
    DocumentReference documentReference3 =
        FirebaseFirestore.instance.collection('chats').doc(silinecekChatismi);
    DocumentSnapshot documentSnapshot3 = await documentReference3.get();
    if (documentSnapshot3['isGroup'] == true) {
      if (documentSnapshot3['creatorId'] != currentUserEmail) {
        List<dynamic> array3 = documentSnapshot3['users'];
        array3.remove(currentUserEmail);
        documentReference3.update({'users': array3});
      } else {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(silinecekChatismi)
            .delete()
            .then(
              (doc) => debugPrint("Document deleted"),
              onError: (e) => debugPrint("Error updating document $e"),
            );
      }
      documentSnapshot3['creatorEmail'] == currentUserEmail
          ? FirebaseFirestore.instance
              .collection('chats')
              .doc(silinecekChatismi)
              .delete()
              .then(
                (doc) => debugPrint("Document deleted"),
                onError: (e) => debugPrint("Error updating document $e"),
              )
          : null;
    } else {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(silinecekChatismi)
          .delete()
          .then(
            (doc) => debugPrint("Document deleted"),
            onError: (e) => debugPrint("Error updating document $e"),
          );
    }
  }

  void deleteCheck(String silinecekChatismi, List<dynamic> silinecekIdler,
      String creatorEmail, String toEmail) {
    showDialog(
      barrierDismissible: false,
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
                await ownerCheck(silinecekChatismi).then((value) {
                  //  setState(() {
                  //  });

                  gelen = value;
                  if (gelen.contains(FirebaseAuth.instance.currentUser!.uid)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The chat is successfully deleted.'),
                      ),
                    );

                    deleteChat(silinecekChatismi, silinecekIdler, creatorEmail,
                        toEmail);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This chat is not yours'),
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

  Future<List<dynamic>> ownerCheck(String chatismi) async {
    var gelen = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatismi)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        return data['owner'];
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );

    return gelen;
  }

  /* Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: FittedBox(
                      child: widget.gelenAvatar,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        widget.chatName,
                        style: const TextStyle(fontSize: 39),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 10, right: 4, left: 8.0, top: 1),
                            child: Text(
                              'Group',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 10, right: 8.0, left: 4, top: 1),
                            child: Text(
                              '6 participants',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 0.0, right: 8.0, left: 8.0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 0, right: 15, left: 13, top: 5),
                          child: Column(children: [
                            Icon(
                              Icons.call,
                              size: 35,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 0, right: 13, left: 13, top: 5),
                          child: Column(children: [
                            Icon(
                              Icons.video_call,
                              size: 35,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 0, right: 13, left: 13, top: 5),
                          child: Column(children: [
                            Icon(
                              Icons.search,
                              size: 35,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 8.0, right: 8.0, left: 8.0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Audio'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Video'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Search'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width,
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add group description'),
                    SizedBox(
                      height: 6,
                    ),
                    Text('Created by USER, DATE:'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Media, links, and docs,'),
                        Icon(Icons.turn_right)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              child: const Column(
                children: [
                  ListTile(
                      title: Text(
                          style: TextStyle(fontSize: 16.5),
                          'Mute notifications'),
                      leading: Icon(Icons.notifications)),
                  ListTile(
                      title: Text(
                          style: TextStyle(fontSize: 16.5),
                          'Custom notification'),
                      leading: Icon(Icons.music_note)),
                  ListTile(
                      title: Text(
                          style: TextStyle(fontSize: 16.5), 'Media visibility'),
                      leading: Icon(Icons.image)),
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              child: const Column(
                children: [
                  ListTile(
                      title:
                          Text(style: TextStyle(fontSize: 16.5), 'Encryption'),
                      leading: Icon(Icons.enhanced_encryption)),
                  ListTile(
                      title: Text(
                          style: TextStyle(fontSize: 16.5),
                          'Disappearing messages'),
                      leading: Icon(Icons.timelapse)),
                  ListTile(
                      title:
                          Text(style: TextStyle(fontSize: 16.5), 'Chat lock'),
                      leading: Icon(Icons.lock)),
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              child: const Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 14, left: 14, top: 8, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('participants'), Icon(Icons.search)],
                    ),
                  ),
                  ListTile(
                      title: Text(style: TextStyle(fontSize: 16.5), 'data'),
                      leading: Icon(Icons.abc)),
                  ListTile(
                      title: Text(style: TextStyle(fontSize: 16.5), 'data'),
                      leading: Icon(Icons.abc)),
                  ListTile(
                      title: Text(style: TextStyle(fontSize: 16.5), 'data'),
                      leading: Icon(Icons.abc)),
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              color: Colors.white,
              child: const Column(
                children: [
                  ListTile(
                      title: Text('Exit group'),
                      leading: Icon(Icons.exit_to_app)),
                  ListTile(
                      title: Text('Report group'),
                      leading: Icon(Icons.thumb_down)),
                ],
              ),
            ),
          ],
        ),
      ),
    )  */
}
