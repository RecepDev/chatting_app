import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:chatting_app/main.dart';
import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:chatting_app/model/user_database_provider.dart';
import 'package:chatting_app/model/user_model.dart';
import 'package:chatting_app/screens/0_chats_screen.dart';
import 'package:chatting_app/screens/1_updates_screen.dart';
import 'package:chatting_app/screens/2_calls_screen.dart';
import 'package:chatting_app/screens/call_screen.dart';
import 'package:chatting_app/screens/create.dart';
import 'package:chatting_app/utility/utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //final navigatorKey = GlobalKey<NavigatorState>();
  List<String> userUidList = [];
  late String gelenId = '';
  String title = 'ChainChat';
  String lastMessage = 'sa';
  File? _pickedImageFile;
  late String gonderilecekChatName;
  late bool isEmpty;
  bool isChatPressed = false;
  bool isServiceActive = true;
  List<String> urls = [];
  List<String> urlsForStart = [];
  List<String> futureDenemeList = [];
  List<String> personalList = [];
  List<String> denemeList = [];
  late Duration callDurations = const Duration();

  List<dynamic> photoList = [];
  late TabController _tabController;
  late String sa;

  bool check = false;
  int intt = 0;
  List idList = [];
  bool isThereUpdatesany = true;
  bool incomingCall = false;
  late String myId = '';
  final Duration interval = const Duration(seconds: 5);
  late String myPhoneId = '';
  late String voiceCallId = '';
  late String usernameforcall = '';
  late int callerId = 0;
  late String callerType = '';

  late ZegoCallUser callerName;
  late String callType = '';
  late List callees = [];
  late String custom = '';
  late String myUsername = '';
  late String myEmail = '';
  late String myImageUrl = '';
  late String myVoiceCallId = '';
  late Future<UserModel?> calluser;
  late String getterId = '';
  List<String> callerIds = [];
  List<String> callerNames = [];

  String cacheEmail = '';
  String cacheuserName = '';
  String cacheimageUrl = '';
  int cachevoiceCallId = 0;
  String cacheisCanceled = '';
  String cachemessage = '';
  String cacheCancelTime = '';
  String cacheisIncoming = '';
  String cacheisTimeout = '';
  String cacheisVideo = '';
  String cachetoWhere = '';
  String cacheinfo = '';
  String cacheisGroup = '';
  String cacheGroup = '';
  String cacheGroupName = '';
  String cacheGroupImage = '';
  List<String> cacheGroupIds = [];
  late String providerCacheDocId;
  late bool providerIsGroup;
  String cacheDocId = '';
  bool isAccepted = false;

  String? currentUserEmail;
  String? userUid;

  // CallerIdNotifier? userProvider;

  int minutes = 00;
  int seconds = 00;
  bool isTimerRunning = false;
  late Timer timer;

  late List<Map<String, dynamic>> callsEventList;

  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  UserModel? receiver;

  final TextEditingController _controller = TextEditingController();
  final callInvitationController = ZegoUIKitPrebuiltCallController();

  @override
  void initState() {
    super.initState();

    localDatabase.initialize().then((value) {
      userToDatabase();
      userCheck(userUid!);
    });
    setupPushNotifications();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabController.animation?.addListener(() {
      Provider.of<CallerIdNotifier>(context, listen: false)
          .changeTabindex((_tabController.animation!.value).round());
    });

    //  userCheck(userUid);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (isServiceActive) {
          Timer.periodic(interval, (timer) {
            userCheck(userUid!);
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .get()
              .then(
            (value) {
              myUsername = value['username'];
              myEmail = value['email'];
              myImageUrl = value['image_url'];
              myVoiceCallId = value['voiceCallId'];
              debugPrint(
                  '------------------------------------SERVİCE ÇALIŞTI --------------------------------');
              ZegoUIKitPrebuiltCallInvitationService().init(
                appID: utility.appId,
                appSign: utility.appSignIn,
                userID: value['voiceCallId'],
                userName: value['username'],
                plugins: [ZegoUIKitSignalingPlugin()],
                events: ZegoUIKitPrebuiltCallInvitationEvents(
                    //!     I N C O M I N G
                    onIncomingCallReceived: (
                  String callID,
                  ZegoCallUser caller,
                  ZegoCallType callType,
                  List callees,
                  String customData,
                ) {
                  callerType = callType.toString();
                  incomingCall = true;

                  if (customData == 'false') {
                    cacheisGroup = 'false';

                    callerId = int.parse(caller.id);
                    /*   print(
                          '----------------------------${caller.name}--------------------------------'); */
                    callerNames.add(caller.name);
                  } else {
                    cacheDocId = customData;
                    cacheisGroup = 'true';

                    for (ZegoCallUser callees in callees) {
                      callerIds.add(callees.id);
                      callerNames.add(callees.name);
                    }
                    callerIds.remove(value['voiceCallId']);
                    callerIds.add(caller.id);
                    callerNames.remove(value['username']);
                    callerNames.add(caller.name);

                    /*     print(callerIds);
                      print(callerNames);

                      print(
                          '----------------------------${caller.name}aaabbbccc--------------------------------'); */
                  }
                },
                    //* ÇALIŞIYOR
                    onIncomingCallDeclineButtonPressed: () async {
                  DateTime inComingTime = DateTime.now();
                  if (cacheisGroup == 'false') {
                    UserModel? caller =
                        await userDatabaseProvider.getUser(callerId);

                    userDatabaseProvider.insertUserForList(
                        UserModel(
                            mail: caller!.mail,
                            userName: caller.userName,
                            imageUrl: caller.imageUrl,
                            voiceCallId: caller.voiceCallId),
                        'Canceled',
                        inComingTime.toString(),
                        'true',
                        'true',
                        'false',
                        callerType,
                        'Incoming',
                        '',
                        cacheisGroup);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(cacheDocId)
                        .get()
                        .then((value) {
                      userDatabaseProvider.insertGroupForList(
                          value['toUsername'],
                          callerIds,
                          callerNames,
                          value['toimageUrl'],
                          'Canceled',
                          inComingTime.toString(),
                          'true',
                          'true',
                          'false',
                          callerType,
                          'Incoming',
                          '',
                          cacheisGroup,
                          cacheDocId);
                    });
                  }
                },
                    //* ÇALIŞIYOR
                    onIncomingCallCanceled:
                        (String callID, ZegoCallUser caller) async {
                  DateTime inComingTime = DateTime.now();

                  if (cacheisGroup == 'false') {
                    UserModel? callerr = await userDatabaseProvider
                        .getUser(int.parse(caller.id));

                    userDatabaseProvider.insertUserForList(
                        UserModel(
                            mail: callerr!.mail,
                            userName: callerr.userName,
                            imageUrl: callerr.imageUrl,
                            voiceCallId: callerr.voiceCallId),
                        'false',
                        inComingTime.toString(),
                        'false',
                        'true',
                        'true',
                        callerType,
                        'Canceled',
                        '',
                        cacheisGroup);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(cacheDocId)
                        .get()
                        .then((value) {
                      userDatabaseProvider.insertGroupForList(
                          value['toUsername'],
                          callerIds,
                          callerNames,
                          value['toimageUrl'],
                          'false',
                          inComingTime.toString(),
                          'false',
                          'true',
                          'true',
                          callerType,
                          'Canceled',
                          '',
                          cacheisGroup,
                          cacheDocId);
                    });
                  }
                },
                    //* ÇALIŞIYOR
                    onIncomingCallTimeout:
                        (String callID, ZegoCallUser caller) async {
                  DateTime inComingTime = DateTime.now();

                  if (cacheisGroup == 'false') {
                    UserModel? callerr = await userDatabaseProvider
                        .getUser(int.parse(caller.id));
                    userDatabaseProvider.insertUserForList(
                        UserModel(
                            mail: callerr!.mail,
                            userName: callerr.userName,
                            imageUrl: callerr.imageUrl,
                            voiceCallId: callerr.voiceCallId),
                        'false',
                        inComingTime.toString(),
                        'false',
                        'true',
                        'true',
                        callerType,
                        'Missed',
                        '',
                        cacheisGroup);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(cacheDocId)
                        .get()
                        .then((value) {
                      userDatabaseProvider.insertGroupForList(
                          value['toUsername'],
                          callerIds,
                          callerNames,
                          value['toimageUrl'],
                          'false',
                          inComingTime.toString(),
                          'false',
                          'true',
                          'true',
                          callerType,
                          'Missed',
                          '',
                          cacheisGroup,
                          cacheDocId);
                    });
                  }
                },
                    //* ÇALIŞIYOR
                    onOutgoingCallDeclined:
                        (String callID, ZegoCallUser callee) async {
                  DateTime inComingTime = DateTime.now();

                  if (providerIsGroup == false) {
                    print(
                        '------------------------7 bölum çalişti----------------------');
                    UserModel? caller = await userDatabaseProvider
                        .getUser(int.parse(callee.id));
                    userDatabaseProvider.insertUserForList(
                        UserModel(
                            mail: caller!.mail,
                            userName: caller.userName,
                            imageUrl: caller.imageUrl,
                            voiceCallId: caller.voiceCallId),
                        'false',
                        inComingTime.toString(),
                        'true',
                        'false',
                        'true',
                        callID,
                        'Declined',
                        '',
                        cacheisGroup);
                    //navigatorKey.currentState?.pop();
                  } else {
                    print(
                        '------------------------8 bölum çalişti----------------------');

                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(providerCacheDocId)
                        .get()
                        .then((value) {
                      userDatabaseProvider.insertGroupForList(
                          value['toUsername'],
                          callerIds,
                          callerNames,
                          value['toimageUrl'],
                          'false',
                          inComingTime.toString(),
                          'true',
                          'false',
                          'true',
                          callID,
                          'Declined',
                          '',
                          cacheisGroup,
                          incomingCall == true
                              ? cacheDocId
                              : providerCacheDocId);
                      // navigatorKey.currentState?.pop();
                    });
                  }
                }, onIncomingCallAcceptButtonPressed: () async {
                  DateTime inComingTime = DateTime.now();

                  if (cacheisGroup == 'false') {
                    UserModel? caller =
                        await userDatabaseProvider.getUser(callerId);
                    startTimer();
                    cacheEmail = caller!.mail;
                    cacheuserName = caller.userName;
                    cacheimageUrl = caller.imageUrl;
                    cachevoiceCallId = caller.voiceCallId;
                    cacheisCanceled = 'false';
                    cachemessage = inComingTime.toString();
                    cacheCancelTime = 'false';
                    cacheisIncoming = 'true';
                    cacheisTimeout = 'false';
                    cacheisVideo = callerType;
                    cachetoWhere = 'Incoming';
                    cacheinfo = '';
                    cacheGroup = 'false';
                    isAccepted = true;
                  } else {
                    startTimer();

                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(cacheDocId)
                        .get()
                        .then((value) {
                      cacheGroupName = value['toUsername'];
                      cacheGroupImage = value['toimageUrl'];
                      cacheGroupIds = callerIds;
                      cacheisCanceled = 'false';
                      cachemessage = inComingTime.toString();
                      cacheCancelTime = 'false';
                      cacheisIncoming = 'true';
                      cacheisTimeout = 'false';
                      cacheisVideo = callerType;
                      cachetoWhere = 'Incoming';
                      cacheinfo = '';
                      cacheGroup = 'true';
                      isAccepted = true;
                    });
                  }
                }, onOutgoingCallAccepted:
                        (String callID, ZegoCallUser callee) async {
                  DateTime inComingTime = DateTime.now();
                  print(
                      '--------------------callaccpeted $providerIsGroup-----------------');
                  if (providerIsGroup == false) {
                    print(
                        '-------------------------------1 USER BÖLUM ÇALISTI------------------------');
                    UserModel? caller = await userDatabaseProvider
                        .getUser(int.parse(callee.id));
                    startTimer();
                    cacheEmail = caller!.mail;
                    cacheuserName = caller.userName;
                    cacheimageUrl = caller.imageUrl;
                    cachevoiceCallId = caller.voiceCallId;
                    cacheisCanceled = 'false';
                    cachemessage = inComingTime.toString();
                    cacheCancelTime = 'false';
                    cacheisIncoming = 'false';
                    cacheisTimeout = 'false';
                    cacheisVideo = callID;
                    cachetoWhere = 'Outgoing';
                    cacheinfo = '';
                    cacheGroup = 'false';
                    isAccepted = true;
                  } else {
                    startTimer();
                    print(
                        '-------------------------------2 GROUP BÖLUM ÇALISTI------------------------');
                    print(providerCacheDocId);
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(providerCacheDocId)
                        .get()
                        .then((value) {
                      cacheGroupName = value['toUsername'];
                      cacheGroupImage = value['toimageUrl'];
                      cacheGroupIds = callerIds;
                      cacheisCanceled = 'false';
                      cachemessage = inComingTime.toString();
                      cacheCancelTime = 'false';
                      cacheisIncoming = 'false';
                      cacheisTimeout = 'false';
                      cacheisVideo = callID;
                      cachetoWhere = 'Outgoing';
                      cacheinfo = '';
                      cacheGroup = 'true';
                      isAccepted = true;
                    });
                  }
                }),
                requireConfig: (ZegoCallInvitationData data) {
                  var config = (data.invitees.length > 1)
                      ? ZegoCallType.videoCall == data.type
                          ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                          : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                      : ZegoCallType.videoCall == data.type
                          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

                  //! show minimizing button
                  config.topMenuBarConfig.isVisible = true;
                  config.topMenuBarConfig.buttons
                      .insert(0, ZegoMenuBarButtonName.minimizingButton);

                  config.onOnlySelfInRoom = (ctx) {
                    if (isAccepted == true) {
                      if (cacheGroup == 'false') {
                        print(
                            '------------------------------- 3 USER BÖLUM ÇALISTI------------------------');
                        //print(providerCacheDocId);
                        userDatabaseProvider
                            .insertUserForList(
                                UserModel(
                                    mail: cacheEmail,
                                    userName: cacheuserName,
                                    imageUrl: cacheimageUrl,
                                    voiceCallId: cachevoiceCallId),
                                cacheisCanceled,
                                cachemessage,
                                cacheCancelTime,
                                cacheisIncoming,
                                cacheisTimeout,
                                cacheisVideo,
                                cachetoWhere,
                                '$minutes:$seconds',
                                'false')
                            .then((value) {
                          callerIds = [];
                          stopTimer();
                        });
                        /*  Navigator.of(ctx).push(MaterialPageRoute(
                          builder: (ctx) => const HomePage(),
                        )); */
                        navigatorKey.currentState?.pop();
                        //navigatorKey.currentState?.pop();
                      } else {
                        print(
                            '------------------------------- 4 GROUP BÖLUM ÇALISTI------------------------');
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(incomingCall == true
                                ? cacheDocId
                                : providerCacheDocId)
                            .get()
                            .then((value) {
                          userDatabaseProvider
                              .insertGroupForList(
                                  value['toUsername'],
                                  callerIds,
                                  callerNames,
                                  value['toimageUrl'],
                                  cacheisCanceled,
                                  cachemessage,
                                  cacheCancelTime,
                                  cacheisIncoming,
                                  cacheisTimeout,
                                  cacheisVideo,
                                  cachetoWhere,
                                  '$minutes:$seconds',
                                  'true',
                                  incomingCall == true
                                      ? cacheDocId
                                      : providerCacheDocId)
                              .then((value) {
                            callerIds = [];
                            stopTimer();
                          });
                        });
                        /* Navigator.of(ctx).push(MaterialPageRoute(
                          builder: (ctx) => const HomePage(),
                        )); */
                        navigatorKey.currentState?.pop();
                        //navigatorKey.currentState?.pop();
                      }
                      isAccepted == false;

                      // navigatorKey.currentState?.pop();
                    } else {
                      /*  Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (ctx) => const HomePage(),
                      )); */
                      navigatorKey.currentState?.pop();
                    }

                    incomingCall = false;
                  };
                  config.onHangUp = () async {
                    if (isAccepted == true) {
                      if (cacheGroup == 'false') {
                        print(
                            '-------------------------------5 USER BÖLUM ÇALISTI------------------------');
                        userDatabaseProvider
                            .insertUserForList(
                                UserModel(
                                    mail: cacheEmail,
                                    userName: cacheuserName,
                                    imageUrl: cacheimageUrl,
                                    voiceCallId: cachevoiceCallId),
                                cacheisCanceled,
                                cachemessage,
                                cacheCancelTime,
                                cacheisIncoming,
                                cacheisTimeout,
                                cacheisVideo,
                                cachetoWhere,
                                '$minutes:$seconds',
                                'false')
                            .then((value) {
                          callerIds = [];
                          stopTimer();
                        });
                        /* navigatorKey.currentState?.pushNamed('/home'); */
                        navigatorKey.currentState?.pop();
                      } else {
                        print(
                            '------------------------------- 6 GROUP BÖLUM ÇALISTI------------------------');
                        print(incomingCall);
                        await FirebaseFirestore.instance
                            .collection('chats')
                            .doc(incomingCall == true
                                ? cacheDocId
                                : providerCacheDocId)
                            .get()
                            .then((value) {
                          userDatabaseProvider
                              .insertGroupForList(
                                  value['toUsername'],
                                  callerIds,
                                  callerNames,
                                  value['toimageUrl'],
                                  cacheisCanceled,
                                  cachemessage,
                                  cacheCancelTime,
                                  cacheisIncoming,
                                  cacheisTimeout,
                                  cacheisVideo,
                                  cachetoWhere,
                                  '$minutes:$seconds',
                                  'true',
                                  incomingCall == true
                                      ? cacheDocId
                                      : providerCacheDocId)
                              .then((value) {
                            callerIds = [];
                            stopTimer();
                          });
                        });
                        /*  navigatorKey.currentState?.pushNamed('/home'); */
                        navigatorKey.currentState?.pop();
                      }

                      isAccepted == false;
                    } else {
                      navigatorKey.currentState?.pop();
                    }
                    /*  navigatorKey.currentState?.pushNamed('/home'); */

                    incomingCall = false;
                  };

                  return config;
                },
              );
            },
          );
          isServiceActive = false;
        }
      },
    );
  }

  @override
  void dispose() {
    if (isTimerRunning) {
      timer.cancel();
    }
    _tabController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    //final bool isValue = ref.watch(boolProvider.notifier);
    //userProvider = Provider.of<CallerIdNotifier>(context, listen: true);
    var selectedTabIndex = Provider.of<CallerIdNotifier>(context, listen: true)
        .getselectedTabIndexProvider;
    final List<IconData> icons = [Icons.message, Icons.camera_alt, Icons.call];
    providerCacheDocId =
        Provider.of<CallerIdNotifier>(context, listen: true).getdocId;

    providerIsGroup =
        Provider.of<CallerIdNotifier>(context, listen: true).getisGroup;
    print(providerIsGroup);
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
                unselectedLabelColor: const Color.fromARGB(255, 180, 180, 180),
                indicatorColor: Colors.white,
                labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                labelColor: Colors.white,
                onTap: (value) {},
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Chats',
                  ),
                  Tab(
                    text: 'Updates',
                  ),
                  Tab(
                    text: 'Calls',
                  )
                ]),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )),
              ),
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
                            showConfirmationDialog(context);
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
            ],
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(content: Text('aaa')),
            child: Stack(
              children: [
                TabBarView(controller: _tabController, children: const [
                  ChatsScreen(),
                  UpdatesScreen(),
                  CallsList(),
                ]),

                // BOTTOM BUTTON
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
                        if ((_tabController.animation!.value).round() == 0) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child:
                                      CreateChat(showConfirmationDialog, 'as'),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200)));
                        }
                        if ((_tabController.animation!.value).round() == 1) {
                          _pickImage();
                        }
                        if ((_tabController.animation!.value).round() == 2) {
                          //  _pickImage();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CallScreen(
                                      localUserId: myId,
                                      myEmail: myEmail,
                                      myImageUrl: myImageUrl,
                                      myName: myUsername,
                                      myVoiceCallId: myVoiceCallId),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200)));
                        }

                        /* setState(() {
                                newChatCheck();
                              }); */
                      },
                      icon: Icon(
                        icons[selectedTabIndex],
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                ZegoUIKitPrebuiltCallMiniOverlayPage(
                  contextQuery: () {
                    return navigatorKey.currentState!.context;
                  },
                ),
              ],
            ),
          ),
        ),
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
                isServiceActive = true;
                ZegoUIKitPrebuiltCallInvitationService().uninit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  void getUsersUpdates(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      int index) async {
    var storageRef2 = FirebaseStorage.instance
        .ref()
        .child('update_images')
        .child(snapshot.data!.docs[index]['UserUid']);

    await storageRef2
        .getDownloadURL()
        .then((url) => urlsForStart.add(url.toString()));
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result2 = await storage
        .ref('/update_images/${snapshot.data!.docs[index]['UserUid']}}')
        .listAll();

    for (Reference ref in result2.items) {
      String downloadURL = await ref.getDownloadURL();
      urlsForStart.add(downloadURL);

      await FirebaseFirestore.instance
          .collection('updates')
          .doc(snapshot.data!.docs[index]['UserUid'])
          .set({
        'userUid': snapshot.data!.docs[index]['UserUid'],
        'userEmail': snapshot.data!.docs[index]['email'],
        'photos': urlsForStart,
      }).then((value) {
        urlsForStart = [];
      });
    }
  }

  void deneme2(String gelenUid) async {
    // debugPrint('deneme2  Çalişti');

    FirebaseStorage storage = FirebaseStorage.instance;
    // Klasördeki tüm dosyaların referanslarını alın
    debugPrint(gelenUid);
    ListResult result = await storage.ref('/update_images/$gelenUid').listAll();
    if (result.items.isEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(gelenUid)
          .update({
        'hasUpdate': false,
        'photos': [],
      }).then((value) {
        // futureDenemeList = [];
      });
    } else {
      for (Reference ref in result.items) {
        String downloadURL2 = await ref.getDownloadURL();
        futureDenemeList.add(downloadURL2);

        //userUidList = [];
        //  futureDenemeList = [];
        if (futureDenemeList.length == result.items.length) {
          if (futureDenemeList.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(gelenUid)
                .update({
              'hasUpdate': true,
              'photos': futureDenemeList,
            }).then((value) {
              //futureDenemeList = [];
            });
            // futureDenemeList = [];
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(gelenUid)
                .update({
              'hasUpdate': false,
              'photos': [],
            }).then((value) {
              // futureDenemeList = [];
            });
            //futureDenemeList = [];
          }
        }
      }
    }

    futureDenemeList.clear();
    // userUidList.clear();
  }

  void userCheck(String personelUid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // Klasördeki tüm dosyaların referanslarını alın
    ListResult result =
        await storage.ref('/update_images/$personelUid').listAll();

    for (Reference ref in result.items) {
      String downloadURL2 = await ref.getDownloadURL();
      personalList.add(downloadURL2);
    }
    if (personalList.length == result.items.length) {
      if (personalList.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(personelUid)
            .update({
          'hasUpdate': true,
          'photos': personalList,
        }).then((value) {
          personalList = [];
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(personelUid)
            .update({
          'hasUpdate': false,
          'photos': [],
        }).then((value) {
          personalList = [];
        });
      }
    }
  }

  /*  void usersUpdatecheck() {
    //debugPrint('usersUpdatecheck calişti');
    // debugPrint('${userUidList} thisss');
    for (String uid in userUidList) {
    
      deneme2(uid);
    }
  } */

  void getCallId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) {
      var data = value;
      myId = data['voiceCallId'];
    });
  }

  void method(String email, String userName, String imageUrl,
      String voiceCallId, DocumentSnapshot<Map<String, dynamic>> value) async {
    for (int i = 0; i < value.data()!.keys.length; i++) {
      userDatabaseProvider.insert(UserModel(
          mail: email,
          userName: userName,
          imageUrl: imageUrl,
          voiceCallId: int.parse(voiceCallId)));
    }
  }

  void userToDatabase() async {
    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    final localDatabase = UserDatabaseProvider();
    await localDatabase.initialize();

    //localDatabase.createTable();
    // localDatabase.update();

    final usersQuerySnapshot = await usersCollection.get();
    for (final userDocument in usersQuerySnapshot.docs) {
      if (await localDatabase.isUserAlreadyExists(userDocument['email'])) {
      } else {
        for (final userDocument in usersQuerySnapshot.docs) {
          final userData = userDocument.data();
          localDatabase.insert(UserModel(
              imageUrl: userData['image_url'],
              mail: userData['email'],
              userName: userData['username'],
              voiceCallId: int.parse(userData['voiceCallId'])));
        }
      }
    }
  }

  Future<void> addUser(UserModel user) async {}

  void callAccepted(ZegoCallUser callee) {
    //  String formattedTime =
    //    DateFormat('d MMMM, HH:mm a').format(inComingTime);
    /* DateFormat format =
                  DateFormat('d MMMM, HH:mm'); // <- use skeleton here
              String formattedDate = format.format(inComingTime); */
    //userDatabaseProvider.createTable();
  }

  void updateTimer() {
    // Saniyeleri artır
    seconds++;

    // 60 saniye olduğunda bir dakika ekleyip saniyeleri sıfırla
    if (seconds == 60) {
      seconds = 0;
      minutes++;
    }
  }

  Future<String?> getLastMessagee(List chatNameList) async {
    try {
      for (var list in chatNameList) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(list)
            .collection('aaa') // Koleksiyon adınızı buraya ekleyin
            .orderBy('createdAt',
                descending: true) // Tarih alanının adınızı kullanın
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String sonMesaj = querySnapshot.docs.first['text'];
          return sonMesaj;
        }
      }
    } catch (e) {}

    return null;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateTimer();
    });
    isTimerRunning = true;
  }

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  Future<bool> onWillPop() {
    exit(0);
  }

  void stopTimer() {
    timer.cancel();

    isTimerRunning = false;
    seconds = 0;
    minutes = 0;
  }

  /*  onOutgoingCallRejectedCauseBusy:
                      (String callID, ZegoCallUser callee) async {
                    DateTime inComingTime = DateTime.now();

                    if (providerIsGroup == false) {
                      UserModel? caller = await userDatabaseProvider
                          .getUser(int.parse(callee.id));
                      userDatabaseProvider.insertUserForList(
                          UserModel(
                              mail: caller!.mail,
                              userName: caller.userName,
                              imageUrl: caller.imageUrl,
                              voiceCallId: caller.voiceCallId),
                          'false',
                          inComingTime.toString(),
                          'true',
                          'false',
                          'false',
                          callID,
                          'Busy',
                          'Duration',
                          cacheisGroup);
                    } else {
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(providerCacheDocId)
                          .get()
                          .then((value) {
                        userDatabaseProvider.insertGroupForList(
                            value['toUsername'],
                            callerIds,
                            callerNames,
                            value['toimageUrl'],
                            'false',
                            inComingTime.toString(),
                            'true',
                            'false',
                            'false',
                            callID,
                            'Busy',
                            'Duration',
                            cacheisGroup,
                            cacheDocId);
                      });
                    }
                  }, */
}
