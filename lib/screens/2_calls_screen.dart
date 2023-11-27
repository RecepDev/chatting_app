import 'dart:async';

import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/model/user_database_provider.dart';
import 'package:chatting_app/screens/2.1_history_call_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallsList extends StatefulWidget {
  const CallsList({
    super.key,
  });

  @override
  State<CallsList> createState() => _CallsListState();
}

final localDatabase = UserDatabaseProvider();
List<Map<String, dynamic>> userList = [];
const Duration interval = Duration(seconds: 15);
List<Color> colorList = [Colors.red, Colors.black];
String myVoiceCallId = '';
String myUsername = '';
String myEmail = '';
String myImageUrl = '';
/* CallerIdNotifier? userProvider; */
FirebaseAuth auth = FirebaseAuth.instance;
String? currentUserEmail;
String? userUid;
bool onceWork = true;

//CallerIdNotifier? userProvider;

// final ScrollController _controller = ScrollController();
List<Icon> iconList = [
  const Icon(
    Icons.call_received,
    size: 17,
    color: Colors.red,
  ),
  const Icon(
    Icons.call_received,
    size: 17,
    color: Colors.green,
  ),
  const Icon(
    Icons.call_made,
    size: 17,
    color: Colors.red,
  ),
  const Icon(
    Icons.call_made,
    size: 17,
    color: Colors.green,
  ),
];

class _CallsListState extends State<CallsList> {
  @override
  void initState() {
    super.initState();
    if (onceWork) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          getUsersFromDatabase();
        },
      );
      onceWork = false;
    }

    Timer.periodic(interval, (timer) {
      getUsersFromDatabase();
    });
  }

  void getUsersFromDatabase() {
    localDatabase.getUsers(userUid!).then((value) {
      List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(value);
      if (!mounted) {
        return;
      }

      if (list.length >= 31) {
        // ignore: unused_local_variable
        Map<String, dynamic> silinen = list.removeAt(0);

        localDatabase.updateList(silinen);
      }

      if (list.length == userList.length) {
        return;
      } else {
        setState(() {
          userList = list.reversed.toList();
        });
      }

      /* Provider.of<CallerIdNotifier>(context, listen: false)
            .changeUserList(); */

      //  debugPrint(userList[0]['userName']);
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;

    //userProvider = Provider.of<CallerIdNotifier>(context, listen: true);

    // userList = Provider.of<CallerIdNotifier>(context, listen: true).getuserList;
    return ListView.builder(
      cacheExtent: 0,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      //reverse: true,
      //controller: ScrollController(),
      // padding: const EdgeInsets.all(5),

      itemCount: userList.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          //dragStartBehavior: DragStartBehavior.start,
          //padding: const EdgeInsets.all(10),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: CallsDetailScreen(
                        callId: userList[index]['voiceCallId'],
                        date: userList[index]['CancelTime'],
                        email: userList[index]['email'],
                        imageUrl: userList[index]['imageUrl'],
                        info: userList[index]['info'],
                        message: userList[index]['message'],
                        name: userList[index]['userName'],
                        toWhere: userList[index]['toWhere'],
                        isGroup: userList[index]['isGroup'],
                        myVoiceCallId: myVoiceCallId,
                        gelenIcon: iconSecimi(index),
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 200)));
            },
            contentPadding:
                const EdgeInsets.only(left: 15, right: 5, bottom: 4),
            trailing: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              spacing: 5,
              children: [
                actionButton(
                    userList[index]['isVideo'] == 'ZegoCallType.videoCall',
                    userList[index]['voiceCallId'],
                    userList[index]['userName'],
                    userList[index]['isGroup'] == 'true' ? true : false,
                    userList[index]['isGroup'] == 'true'
                        ? userList[index]['callerNames']
                        : 'bbb',
                    context,
                    userList[index]['isGroup'] == 'true'
                        ? userList[index]['docId']
                        : 'ccc'),
              ],
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(userList[index]['imageUrl']),
              backgroundColor: Colors.transparent,
            ),
            title: Text(
              userList[index]['userName'],
              style: TextStyle(color: colorSecimi(index), fontSize: 17),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    iconSecimi(index),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(callDate(userList[index]['CancelTime'])),
                  ],
                ),
                textgonder(index),
              ],
            ),
          ),
        );
      },
    );
  }
}

Color colorSecimi(int index) {
  if (userList[index]['isIncoming'] == 'true') {
    if (userList[index]['isCanceled'] == 'true' ||
        userList[index]['isTimeout'] == 'true') {
      return colorList[0];
    } else {
      return colorList[1];
    }
  } else {
    if (userList[index]['isTimeout'] == 'true') {
      return colorList[0];
    } else {
      return colorList[1];
    }
  }
}

Icon iconSecimi(int index) {
  if (userList[index]['isIncoming'] == 'true') {
    if (userList[index]['isCanceled'] == 'true' ||
        userList[index]['isTimeout'] == 'true') {
      return iconList[0];
    } else {
      //debugPrint('${userList[index]['isCanceled']}+asdasdasdasdas');
      return iconList[1];
    }
  } else {
    if (userList[index]['isTimeout'] == 'true') {
      return iconList[2];
    } else {
      //debugPrint('${userList[index]['isCanceled']}+asdasdasdasdas');
      return iconList[3];
    }
  }
}

ZegoSendCallInvitationButton actionButton(
    bool isVideo,
    String gelenId,
    String gelenName,
    bool isGroup,
    String callerNames,
    BuildContext context,
    String docId) {
  List<ZegoUIKitUser> aranacakList = [];
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) {
      if (isGroup) {
        Provider.of<CallerIdNotifier>(context, listen: false)
            .changeDocId(docId);
        Provider.of<CallerIdNotifier>(context, listen: false)
            .changeIsGroup(true);
        String gelenIds = gelenId.substring(1, gelenId.length - 1);
        String callerNamess = callerNames.substring(1, callerNames.length - 1);

        List<String> aranacakIds = gelenIds.split(', ');
        List<String> aranacakNames = callerNamess.split(', ');
        //print(aranacakNames);
        for (int i = 0; i < aranacakIds.length; i++) {
          aranacakList
              .add(ZegoUIKitUser(id: aranacakIds[i], name: aranacakNames[i]));
        }
      } else {
        Provider.of<CallerIdNotifier>(context, listen: false)
            .changeIsGroup(false);
      }
    },
  );

  return ZegoSendCallInvitationButton(
      buttonSize: const Size(44, 44),
      iconSize: const Size(44, 44),
      customData: isGroup ? docId : 'false',
      icon: isVideo
          ? ButtonIcon(icon: const Icon(Icons.video_call))
          : ButtonIcon(icon: const Icon(Icons.call)),
      resourceID: 'aaabbb',
      invitees: isGroup
          ? aranacakList
          : [ZegoUIKitUser(id: gelenId, name: gelenName)],
      isVideoCall: isVideo);
}

Widget textgonder(int index) {
  if (userList[index]['message'] == 'false') {
    return const SizedBox();
  } else {
    return Text(userList[index]['message']);
  }
}

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

String callDate(String gelenTime) {
  DateTime gelenDate;
  //print(gelenTime);
  if (gelenTime.isEmpty) {
    gelenTime = DateTime.now().toString();
  }
  gelenDate = DateTime.parse(gelenTime);
  Duration difference = DateTime.now().difference(gelenDate);

  String formattedTimeDifference = formatDuration(difference);
  return formattedTimeDifference;
}
