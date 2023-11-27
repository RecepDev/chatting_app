// ignore_for_file: must_be_immutable

import 'package:chatting_app/screens/1_updates_screen.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallsDetailScreen extends StatelessWidget {
  CallsDetailScreen({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.callId,
    required this.info,
    required this.message,
    required this.toWhere,
    required this.date,
    required this.gelenIcon,
    required this.myVoiceCallId,
    required this.isGroup,
  });

  String imageUrl = '';
  String name = '';
  String email = '';
  String callId = '';
  String info = '';
  String message = '';
  String toWhere = '';
  String date = '';
  String myVoiceCallId = '';
  String isGroup;
  Icon gelenIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Call info',
            style: TextStyle(fontSize: 23, color: Colors.white),
          ),
          leadingWidth: MediaQuery.sizeOf(context).width * 0.08,
          actions: [
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
                        onTap: () {},
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
                })
          ]),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(
              bottom: 0,
              left: 16,
              right: 7,
              top: 0,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(
              name,
              style: const TextStyle(fontSize: 17),
            ),
            subtitle: Text(email),
            trailing: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              children: [
                actionButton(false, callId, name, context,
                    isGroup == 'true' ? true : false),
                actionButton(true, callId, name, context,
                    isGroup == 'true' ? true : false),
              ],
            ),
          ),
          Divider(
              endIndent: 0, indent: MediaQuery.sizeOf(context).width * 0.205),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.595,
              child: const Text('Today'),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Padding(
              padding: const EdgeInsets.only(left: 9, right: 10),
              child: SizedBox(
                height: 28,
                width: 28,
                child: FittedBox(
                  child: gelenIcon,
                ),
              ),
            ),
            title: Text(toWhere),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.call,
                  size: 18,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(callDate(date)),
              ],
            ),
            trailing: Text(info),
          ),
        ],
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(bool isVideo, String gelenId,
      String gelenName, BuildContext ctx, bool isGroup) {
    /* WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (isVideo == true) {
          Provider.of<CallerIdNotifier>(ctx, listen: false)
              .changeCallerType("ZegoCallType.videoCall");
        } else {
          Provider.of<CallerIdNotifier>(ctx, listen: false)
              .changeCallerType("ZegoCallType.voiceCall");
        }
      },
    ); */

    return ZegoSendCallInvitationButton(
        buttonSize: const Size(44, 44),
        iconSize: const Size(44, 44),
        customData: isGroup ? 'true' : 'false',
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

  String callDate(String gelenTime) {
    if (gelenTime.isEmpty) {
      gelenTime = DateTime.now().toString();
    }
    DateTime gelenDate = DateTime.parse(gelenTime);
    Duration difference = DateTime.now().difference(gelenDate);

    String formattedTimeDifference = formatDuration(difference);

    return formattedTimeDifference;
  }
}
